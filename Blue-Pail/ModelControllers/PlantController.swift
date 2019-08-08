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
    
    // MARK: - CRUD
    
    // TODO: Fix optional values
    #warning("Fix Optional Values in CRUD Methods")
    func createPlant(name: String?, image: UIImage?, needsWaterFireDate: Date?, tag: Tag, dayInteger: Int) {
        let imageData: Data?
        if let image = image {
            imageData = image.jpegData(compressionQuality: 1.0)
        } else {
            imageData = nil
        }
        let uuid = UUID()
        let plant = Plant(name: name, isWatered: true, needsWateredFireDate: needsWaterFireDate ?? Date(), image: imageData, uuid: uuid, dayToNextWater: Int16(dayInteger), context: CoreDataStack.context)
        TagController.shared.appendPlantTo(targetTag: tag, desiredPlant: plant)
        scheduleUserNotifications(for: plant)
        saveToPersistentStorage()
    }
    
    
    func updatePlant(plant: Plant, newName: String?, newImage: UIImage?, newFireDate: Date?, newTag: Tag, dayInteger: Int) {
        let imageData: Data?
        if let image = newImage {
            imageData = image.jpegData(compressionQuality: 1.0)
        } else {
            imageData = nil
        }
        plant.name = newName
        plant.image = imageData
        plant.needsWateredFireDate = newFireDate
        plant.dayToNextWater = Int16(dayInteger)
        TagController.shared.appendPlantTo(targetTag: newTag, desiredPlant: plant)
        scheduleUserNotifications(for: plant)
        saveToPersistentStorage()
    }
    
    /// Deletes the target plant from the moc, and saves to persistent storage. Important: Make sure to remove the plant from its tag collection before calling this method.
    func deletePlant(plant: Plant) {
        let moc = plant.managedObjectContext
        moc?.delete(plant)
        cancelUserNotifications(for: plant)
        saveToPersistentStorage()
    }
    
    // MARK: - Additional Helper Methods
    
    /// Sets the target plant's isWatered property to true, and schedules a notification for the argument number of days away from the current date at the correct time. If the current date is less than the fire date the previous firedate will have its notifications removed.
    func waterPlant(plant: Plant) {
        plant.isWatered = true
        guard let fireDate = plant.needsWateredFireDate else { return }
        // Early watering: (want to cancel the previous notification that was scheduled if we are watering before the firedate)
        if Date() < fireDate {
            cancelUserNotifications(for: plant)
        }
        let todayAtCorrectTime = DayHelper.shared.getSameTimeAsDateToday(targetDate: fireDate)
        plant.needsWateredFireDate = DayHelper.shared.futureDateFromADate(givenDate: todayAtCorrectTime, numberOfDays: Int(plant.dayToNextWater))
        scheduleUserNotifications(for: plant)
        saveToPersistentStorage()
    }
    
    /// Waters the plant for now and creates a new notification that is the arguemnt amount of hours away from the fireDate.
    func snoozeWateringFor(plant: Plant, hoursForSnooze: Int) {
        plant.isWatered = true
        guard let fireDate = plant.needsWateredFireDate else { return }
        let dateAfterSnoozeTime = DayHelper.shared.getSameTimeAsDateTodayPlusSomeHours(targetDate: fireDate, givenAmountOfHours: hoursForSnooze)
        plant.needsWateredFireDate = dateAfterSnoozeTime
        scheduleUserNotifications(for: plant)
        saveToPersistentStorage()
    }
    
    /// Returns a UIColor reflecting the target Plants isWatered property (blue for true, yellow for false).
    func colorBasedOnWateredState(plant: Plant) -> UIColor {
        if plant.isWatered == true {
            return UIColor.mintGreen
        } else {
            return UIColor.dryRed
        }
    }
    
    /// Checks if the current date is greater than or equal to the fireDate of the target Plant, if so it sets the plant to dry and saves the changes to persistent storage.
    func checkIfDry(plant:Plant) {
        guard let isDryDate = plant.needsWateredFireDate else { return }
        let currentDate = Date()
        if currentDate >= isDryDate {
            plant.isWatered = false
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
    
    // MARK: - Persistence
    
    func saveToPersistentStorage() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print(error)
        }
    }
}

// MARK: - AlarmScheduler Protocol

protocol AlarmScheduler {
    func scheduleUserNotifications(for plant: Plant)
    func cancelUserNotifications(for plant: Plant)
}

extension AlarmScheduler {
    func scheduleUserNotifications(for plant: Plant) {
        let content  = UNMutableNotificationContent()
        content.title = "Time To Water!"
        content.body = "Water your \(plant.name ?? "plant")!"
        content.sound = UNNotificationSound.default
        content.userInfo = [Keys.userInfoPlantName : plant.name!]
        content.categoryIdentifier = Keys.plantNotificationCatagoryIdentifier
        let calendar = Calendar.current
        let dateCompoenents = calendar.dateComponents([.day, .hour, .minute], from: plant.needsWateredFireDate ?? Date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateCompoenents, repeats: false)
        let request = UNNotificationRequest(identifier: plant.uuid!.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to add notification request. \(error.localizedDescription)")
            }
        }
        print("Notification succesfully added for plant \(plant.name!)")
    }
    
    func cancelUserNotifications(for plant: Plant) {
        if let plantID = plant.uuid?.uuidString {
            let userNotifcations = UNUserNotificationCenter.current()
            userNotifcations.removePendingNotificationRequests(withIdentifiers: [plantID])
            print("Alarm with UUID: \(plantID) had its notification request removed.")
        }
    }
}
