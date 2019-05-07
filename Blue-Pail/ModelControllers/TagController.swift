//
//  TagController.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/6/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

class TagController {
    
    // MARK: - Shared Instance
    
    static let shared = TagController()
    
    // MARK: - CRUD
    
    // ?? Could this act as both a create and update function?
    func createTag(withPlant plant: Plant, title: String?, colorNumber: Double) {
        plant.tag?.title = title
        plant.tag?.colorNumber = colorNumber
    }
    
}
