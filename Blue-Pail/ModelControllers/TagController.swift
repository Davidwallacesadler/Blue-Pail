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
    
    func createTag(tagTitle: String, colorNumber: Double) {
        _ = Tag(title: tagTitle, colorNumber: colorNumber)
        saveToPersistentStorage()
    }
    
    func appendPlantTo(targetTag: Tag, desiredPlant: Plant) {
        targetTag.addToPlants(desiredPlant)
        saveToPersistentStorage()
    }
    
    func updateTag(withPlant plant: Plant, title: String?, colorNumber: Double) {
        plant.tag?.title = title
        plant.tag?.colorNumber = colorNumber
        saveToPersistentStorage()
    }
    
    func removePlantFrom(targetTag: Tag, desiredPlant: Plant) {
        targetTag.removeFromPlants(desiredPlant)
        saveToPersistentStorage()
    }
    
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
    
    // MARK: - Persistence
    
    func saveToPersistentStorage() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print(error)
        }
    }
}

class TagsController2 {
    var tags = [Tag]()// Contains Red, Blue, Green...
    func createPlant(tag: Tag) {
        // create the plant here
        //tag.append(plant)
    }
}

/*
 In a setup
 
 Create all tags when the app is first run -- so that we can access the tag in the tags array and append the selected plant when we want to save.
 
 Tag creation factory -- must create on first run in the app - in app delegate
 
 onFirstLaucnch -- check shotTrest
 
 Tagconroller.shared.createTag -- create all the tags
 
 
 
 */

/*
 You go to make a plant
 You go throught the process (naming, picture, date....)
 If they select a tag
    when you call your createplant method
        you pass in everything including the tag
        after you've initialized the plant
        tag.append(plant)
 
 */
/*
 What if:
 
 
 
 
 
 */

