//
//  TagController.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/6/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import CoreData

class TagController {
    
    // MARK: - Shared Instance
    
    static let shared = TagController()
    
    // MARK: - Fetched Property
    
    var tags: [Tag] {
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        let moc = CoreDataStack.context
        do {
            let result = try moc.fetch(request)
            return result
        } catch {
            return []
        }
    }
    
    // MARK: - CRUD
    
    /// Creates a new Tag object with the passed in title and colorNumber.
    func createTag(tagTitle: String, colorNumber: Double) {
        _ = Tag(title: tagTitle, colorNumber: colorNumber)
        saveToPersistentStorage()
    }
    
    /// Appends the selected Plant object to a target Tag's plant collection.
    func appendPlantTo(targetTag: Tag, desiredPlant: Plant) {
        targetTag.addToPlants(desiredPlant)
        saveToPersistentStorage()
    }
    
    //TODO: - Write a better update function
    /// Updates the selected Tag Object....
    func updateTag(withPlant plant: Plant, title: String?, colorNumber: Double) {
        plant.tag?.title = title
        plant.tag?.colorNumber = colorNumber
        saveToPersistentStorage()
    }
    
    func updateTag(selectedTag: Tag, withNewTitle title: String,withNewColorNumber colorNumber: Double) {
        selectedTag.title = title
        selectedTag.colorNumber = colorNumber
        saveToPersistentStorage()
    }
    
    
    /// Removes the selected Plant object to a target Tag's plant collection.
    func removePlantFrom(targetTag: Tag, desiredPlant: Plant) {
        targetTag.removeFromPlants(desiredPlant)
        saveToPersistentStorage()
    }
    
    /// Deletes the selected Tag from the Tag Collection:
    func deleteTag(selectedTag: Tag) {
        // Remove Notifications for plants
        guard let plants = selectedTag.plants?.array else {
            return
        }
        for plant in plants {
            PlantController.shared.cancelUserNotifications(for: plant as! Plant)
        }
        // Delete the tag
        let moc = selectedTag.managedObjectContext
        moc?.delete(selectedTag)
        saveToPersistentStorage()
    }
    
    // MARK: - Helper Methods
    
    /// Returns the tag with the same title as the argument tag.
    func getSelectedTag(givenTagTitle title: String) -> Tag {
        var selectedTag = Tag()
        for tag in tags {
            guard let tagTitle = tag.title else { return tags[0] }
            if tagTitle == title {
                selectedTag = tag
            }
        }
        return selectedTag
    }
    
    /// Returns true if the given Tag has a unique title.
    func IsTagUnique(givenTagTitle: String) -> Bool {
        var truthValue = true
        for tag in TagController.shared.tags {
            guard let tagTitle = tag.title else { return truthValue }
            if tagTitle == givenTagTitle {
                truthValue = false
                break
            }
        }
        return truthValue
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
