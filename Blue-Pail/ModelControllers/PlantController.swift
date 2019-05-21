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
    
    //TODO: - when the app is opened or when that plant is viewed or whatever you could check how many days have passed since it was last watered and if it's more than the desired amount than change the bool.
    
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
    
    func createPlant(name: String?, image: UIImage?, needsWaterFireDate: Date?, tag: Tag) {
        let imageData: Data?
        if let image = image {
            imageData = image.jpegData(compressionQuality: 1.0)
        } else {
            imageData = nil
        }
        let uuid = UUID()
        let plant = Plant(name: name, isWatered: true, needsWateredFireDate: needsWaterFireDate ?? Date(), image: imageData, uuid: uuid, context: CoreDataStack.context)
        TagController.shared.appendPlantTo(targetTag: tag, desiredPlant: plant)
        scheduleUserNotifications(for: plant)
        saveToPersistentStorage()
    }
    
    // TODO: Make this properly update the tag
    func updatePlant(plant: Plant, newName: String?, newImage: UIImage?, newFireDate: Date?, newTag: Tag) {
        let imageData: Data?
        if let image = newImage {
            imageData = image.jpegData(compressionQuality: 1.0)
        } else {
            imageData = nil
        }
        plant.name = newName
        plant.image = imageData
        plant.needsWateredFireDate = newFireDate
        TagController.shared.appendPlantTo(targetTag: newTag, desiredPlant: plant)
        //TagController.shared.updateTag(withPlant: plant, title: newTagTitle, colorNumber: newColorNumber)
        scheduleUserNotifications(for: plant)
        saveToPersistentStorage()
    }
    
    func deletePlant(plant: Plant) {
        let moc = plant.managedObjectContext
        moc?.delete(plant)
        cancelUserNotifications(for: plant)
        saveToPersistentStorage()
    }
    
    // MARK: - Additional Helper Methods
    
    // Need a function that deals with checking the isWatered Bool - if true set the background color of the desired view to be blue/green and to yellow/brown if false. Or display some icon that shows watered/notwatered state.
    func swapWateredState(plant: Plant) {
//        if plant.isWatered {
//            plant.isWatered = true
//            scheduleUserNotifications(for: plant)
//        } else {
//            plant.isWatered = false
//        }
    }
    
    func colorBasedOnWateredState(plant: Plant) -> UIColor {
        if plant.isWatered == true {
            return UIColor.wateredBlue
        } else {
            return UIColor.dryYellow
        }
    }
    
    // if the current date is greater than or equal to the fireDate then set the plant to dry.
    func checkIfDry(plant:Plant) {
        guard let isDryDate = plant.needsWateredFireDate else { return }
        let currentDate = Date()
        if currentDate >= isDryDate {
            plant.isWatered = false
        }
    }
    
    // Need a function that can run when the notification gets triggered -- meaning when the notification goes off get the plant for that notification and change the isWatered state from true to false.
    
    
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
    // IDEA: maybe have a 'delay' action that will set the notification a desired time interval away from the current time - wont affect day integer - Just a way of one time putting off the notification to a time that better suits the user - in hours.
    // IDEA: maybe have an 'water' action that will run the code required to update the watered property and schedule the next notification
    func scheduleUserNotifications(for plant: Plant) {
        let content  = UNMutableNotificationContent()
        content.title = "Time To Water!"
        content.body = "Water your \(plant.name ?? "plant")!"
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
    
        let dateCompoenents = calendar.dateComponents([.day, .hour, .minute], from: plant.needsWateredFireDate ?? Date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateCompoenents, repeats: true)
        let request = UNNotificationRequest(identifier: plant.uuid!.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to add notification request. \(error.localizedDescription)")
            }
        }
        print("NotificationCenter added the notification for alarm: \(String(describing: plant.name)) with uuid: \(String(describing: plant.uuid?.uuidString)) to go off: \(String(describing: plant.needsWateredFireDate)).")
    }
    
    func cancelUserNotifications(for plant: Plant) {
        if let plantID = plant.uuid?.uuidString {
            let userNotifcations = UNUserNotificationCenter.current()
            userNotifcations.removePendingNotificationRequests(withIdentifiers: [plantID])
            print("Alarm with UUID: \(plantID) had its notification request removed.")
        }
    }
    
}
