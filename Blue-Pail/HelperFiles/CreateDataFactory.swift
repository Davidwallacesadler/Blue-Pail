//
//  CreateDataFactory.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/16/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

class CreateDataFactory {
    static func createData() {
        TagController.shared.createTag(tagTitle: "Houseplants", colorNumber: 1.0)
        TagController.shared.createTag(tagTitle: "Ourdoor Plants", colorNumber: 2.0)
        TagController.shared.createTag(tagTitle: "Herbs", colorNumber: 3.0)
        TagController.shared.createTag(tagTitle: "Succulents", colorNumber: 4.0)
        TagController.shared.createTag(tagTitle: "Ferns", colorNumber: 5.0)
        TagController.shared.createTag(tagTitle: "Cactus", colorNumber: 6.0)
    }
}
