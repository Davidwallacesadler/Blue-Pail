//
//  PlantController.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/6/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import UserNotifications

class PlantController : AlarmScheduler {
    
    // MARK: - Shared Instance / Singelton
    
    static let shared = PlantController()
    
    // MARK: - Fetched Property
    
    var plants: [Plant] {
        let request: NSFetchRequest<Plant> = Plant.fetchRequest()
        let moc = CoreDataStack.context
        do {
            let result = try moc.fetch(request)
            return result
        } catch {
            return []
        }
    }
    
    func getPlants(withUuid id: UUID) -> [Plant] {
        let request: NSFetchRequest<Plant> = Plant.fetchRequest()
        request.predicate = NSPredicate(format: "uuid == \(id)", argumentArray: nil)
        let moc = CoreDataStack.context
        do {
            let result = try moc.fetch(request)
            return result
        } catch {
            return []
        }
    }
    
    // MARK: - CRUD
    
    // TODO: Fix optional values
    #warning("Fix Optional Values in CRUD Methods")
    func createPlant(name: String?,
                     image: UIImage?,
                     needsWateredFireDate: Date,
                     tag: Tag,
                     wateringDayInteger: Int,
                     fertilizingDayInteger: Int?,
                     needsFertilizedFireDate: Date?) {
        let imageData: Data?
        if let image = image {
            imageData = image.jpegData(compressionQuality: 1.0)
        } else {
            imageData = nil
        }
        let uuid = UUID()
        let plant = Plant(name: name,
                          image: imageData,
                          uuid: uuid,
                          dayToNextWater: Int16(wateringDayInteger),
                          daysToNextFertilize: Int16(fertilizingDayInteger ?? 0),
                          isFertilized: true,
                          needsFertilizedFireDate: needsFertilizedFireDate)
        TagController.shared.appendPlantTo(targetTag: tag, desiredPlant: plant)
        scheduleUserNotifications(for: plant,
                                  isSnoozed: false,
                                  snoozeTimeInterval: nil,
                                  givenNotificationName: Keys.waterNotification)
        if needsFertilizedFireDate != nil {
            scheduleUserNotifications(for: plant,
                                      isSnoozed: false,
                                      snoozeTimeInterval: nil,
                                      givenNotificationName: Keys.fertilizerNotification)
        }
        saveToPersistentStorage()
    }
    
    
    func updatePlant(plant: Plant,
                     newName: String?,
                     newImage: UIImage?,
                     newWateringFireDate: Date?,
                     newTag: Tag,
                     daysToNextWater: Int,
                     newFertilizerFireDate: Date?,
                     daysToNextFertilizing: Int?) {
        let imageData: Data?
        if let image = newImage {
            imageData = image.jpegData(compressionQuality: 1.0)
        } else {
            imageData = nil
        }
        if newWateringFireDate != nil {
            cancelUserNotifications(for: plant,
                                    givenNotificationKey: Keys.waterNotificationCatagoryIdentifier)
        }
        if newFertilizerFireDate != nil {
            cancelUserNotifications(for: plant,
                                    givenNotificationKey: Keys.fertilizerNotificationCatagoryIdentifier)
        }
        plant.name = newName
        plant.image = imageData
        plant.needsWateredFireDate = newWateringFireDate
        plant.dayToNextWater = Int16(daysToNextWater)
        plant.needsFertilizedFireDate = newFertilizerFireDate
        plant.daysToNextFertilize = Int16(daysToNextFertilizing ?? 0)
        TagController.shared.appendPlantTo(targetTag: newTag,
                                           desiredPlant: plant)
        if newFertilizerFireDate != nil {
            scheduleUserNotifications(for: plant,
                                      isSnoozed: false,
                                      snoozeTimeInterval: nil,
                                      givenNotificationName: Keys.fertilizerNotification)
        }
        scheduleUserNotifications(for: plant,
                                  isSnoozed: false,
                                  snoozeTimeInterval: nil,
                                  givenNotificationName: Keys.waterNotification)
        saveToPersistentStorage()
    }
    
    /// Deletes the target plant from the moc, and saves to persistent storage. Important: Make sure to remove the plant from its tag collection before calling this method.
    func deletePlant(plant: Plant) {
        if plant.needsFertilizedFireDate != nil {
            cancelUserNotifications(for: plant,
                                    givenNotificationKey: Keys.fertilizerNotificationCatagoryIdentifier)
        }
        if plant.needsWateredFireDate != nil {
            cancelUserNotifications(for: plant,
                                    givenNotificationKey: Keys.waterNotificationCatagoryIdentifier)
        }
        let moc = plant.managedObjectContext
        moc?.delete(plant)
        saveToPersistentStorage()
    }
    
    // MARK: - Additional Helper Methods
    
    ///
    func fertilizePlant(plant: Plant) {
        plant.isFertilized = true
        guard let fireDate = plant.needsFertilizedFireDate else { return }
        if fireDate > Date() {
            cancelUserNotifications(for: plant,
                                    givenNotificationKey: Keys.fertilizerNotificationCatagoryIdentifier)
        }
        let todayAtCorrectTime = DayHelper.shared.getSameTimeAsDateToday(targetDate: fireDate)
        plant.needsFertilizedFireDate = DayHelper.shared.futureDateFromADate(givenDate: todayAtCorrectTime,
                                                                             numberOfDays: Int(plant.daysToNextFertilize))
        scheduleUserNotifications(for: plant,
                                  isSnoozed: false,
                                  snoozeTimeInterval: nil,
                                  givenNotificationName: Keys.fertilizerNotification)
        createFertilizerHistory(forSelectedPlant: plant)
        saveToPersistentStorage()
    }
    
    func waterPlant(plant: Plant) {
        plant.isWatered = true
        guard let fireDate = plant.needsWateredFireDate else { return }
        let todayAtCorrectTime = DayHelper.shared.getSameTimeAsDateToday(targetDate: fireDate)
        plant.needsWateredFireDate = DayHelper.shared.futureDateFromADate(givenDate: todayAtCorrectTime,
                                                                          numberOfDays: Int(plant.dayToNextWater))
        cancelUserNotifications(for: plant,
                                givenNotificationKey: Keys.waterNotificationCatagoryIdentifier)
        scheduleUserNotifications(for: plant,
                                  isSnoozed: false,
                                  snoozeTimeInterval: nil,
                                  givenNotificationName: Keys.waterNotification)
        saveToPersistentStorage()
    }
    
    /// Waters the plant for now and creates a new notification that is the arguemnt amount of hours away from the fireDate.
    func snoozeWateringFor(plant: Plant,
                           hoursForSnooze: Int,
                           givenNotificationName: String) {
        let hoursForSnoozeInSeconds = 3600 * hoursForSnooze
        guard let snoozeTimeInterval = TimeInterval(exactly: hoursForSnoozeInSeconds) else { return }
        scheduleUserNotifications(for: plant,
                                  isSnoozed: true,
                                  snoozeTimeInterval: snoozeTimeInterval,
                                  givenNotificationName: givenNotificationName)
    }
    
    /// Returns a UIColor reflecting the target Plants isWatered property (blue for true, yellow for false).
    func colorBasedOnWateredState(plant: Plant) -> UIColor {
        if plant.isWatered == true {
            return UIColor.mintGreen
        } else {
            return UIColor.dryRed
        }
    }
    
    /// Checks if the current date is greater than or equal to the wateringFireDate of the target Plant.
    func checkIfDry(plant:Plant) {
        guard let isDryDate = plant.needsWateredFireDate else { return }
        let currentDate = Date()
        if currentDate >= isDryDate {
            plant.isWatered = false
            saveToPersistentStorage()
        }
    }
    
    /// Checks if the current date is greater than or equal to the fertilizerFireDate of the target Plant.
    func checkIfFertilized(plant: Plant) {
        guard let needsFertilizedDate = plant.needsFertilizedFireDate else { return }
        if Date() >= needsFertilizedDate {
            plant.isFertilized = false
            saveToPersistentStorage()
        }
    }
    
    /// Returns true if the plant passed in is dry.
    func isPlantDry(plant:Plant) -> Bool {
        if plant.isWatered == false {
            return true
        } else {
            return false
        }
    }
    
    /// Creates a fertilizer history point for the selected plant at the current date.
    func createFertilizerHistory(forSelectedPlant plant: Plant) {
        FertilizerHistoryController.shared.createFertilizerHistory(givenOccurenceDate: Date(), givenParentPlant: plant)
    }
    
    /// Deletes a Fertilizer History point for the selected plant at the current date
    func deleteFertilizerHistory(forSelectedPlant plant: Plant, atDate targetDate: Date) {
        FertilizerHistoryController.shared.deleteFertilizerHistory(selectedOccurenceDate: targetDate, givenParentPlant: plant)
        saveToPersistentStorage()
    }
    
    // MARK: - Persistence
    
    func saveToPersistentStorage() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print(error)
        }
    }
}

// MARK: - AlarmScheduler Protocol & Extension

protocol AlarmScheduler {
    func scheduleUserNotifications(for plant: Plant,
                                   isSnoozed: Bool,
                                   snoozeTimeInterval: TimeInterval?,
                                   givenNotificationName: String)
    func cancelUserNotifications(for plant: Plant,
                                 givenNotificationKey: String)
}

extension AlarmScheduler {
    func scheduleUserNotifications(for plant: Plant,
                                   isSnoozed: Bool,
                                   snoozeTimeInterval: TimeInterval?,
                                   givenNotificationName: String) {
        let content  = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.userInfo = [Keys.userInfoPlantUuid : plant.uuid!]
        switch givenNotificationName {
        case Keys.waterNotification:
            content.title = "Time To Water"
            content.body = "Water your \(plant.name!)."
            content.categoryIdentifier = Keys.waterNotificationCatagoryIdentifier
        case Keys.fertilizerNotification:
            content.title = "Time To Fertilize"
            content.body = "Fertilize your \(plant.name!)."
            content.categoryIdentifier = Keys.fertilizerNotificationCatagoryIdentifier
            if isSnoozed {
                content.userInfo[Keys.userInfoFertilizerSnooze] = true
            }
        default:
            return
        }
        
        if isSnoozed {
            // Use the snooze time interval as the notification trigger:
            if let snoozeTime = snoozeTimeInterval {
                let snoozeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: snoozeTime,
                                                                      repeats: false)
                let identifier = plant.uuid!.uuidString
                let request = UNNotificationRequest(identifier: identifier,
                                                    content: content,
                                                    trigger: snoozeTrigger)
                UNUserNotificationCenter.current().add(request) { (error) in
                    if let error = error {
                        print("Unable to add notification request. \(error.localizedDescription)")
                    }
                }
                print("Snooze Notification successfully added for plant \(plant.name!)")
            }
        } else {
            // Use the fireDate of the plant as the notification trigger:
            let calendar = Calendar.current
            var dateComponents: DateComponents?
            var identifier = ""
            if givenNotificationName == Keys.fertilizerNotification {
                dateComponents = calendar.dateComponents([.day,.hour,.minute],
                                                         from: plant.needsFertilizedFireDate!)
                identifier += "F"
            } else {
                dateComponents = calendar.dateComponents([.day, .hour, .minute],
                                                          from: plant.needsWateredFireDate!)
                identifier += "W"
            }
            let dateTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents!,
                                                            repeats: false)
            identifier += plant.uuid!.uuidString
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content,
                                                trigger: dateTrigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Unable to add notification request. \(error.localizedDescription)")
                }
            }
            if content.categoryIdentifier == Keys.fertilizePlantNotificationAction {
                print("Fertilize Notification sucessfully added for plant \(plant.name!)")
            } else {
                print("Water Notification successfully added for plant \(plant.name!)")
            }
        }
    }
    
    func cancelUserNotifications(for plant: Plant,
                                 givenNotificationKey: String) {
        if let plantID = plant.uuid?.uuidString {
            var requestId = ""
            let userNotifications = UNUserNotificationCenter.current()
            switch givenNotificationKey {
            case Keys.waterNotificationCatagoryIdentifier:
                requestId += "W"
            case Keys.fertilizerNotificationCatagoryIdentifier:
                requestId += "F"
            default:
                print("No notification Key found")
            }
            requestId += plantID
            userNotifications.removePendingNotificationRequests(withIdentifiers: [requestId])
            print("Notification successfully removed for plant \(plant.name!)")
        }
    }
}
