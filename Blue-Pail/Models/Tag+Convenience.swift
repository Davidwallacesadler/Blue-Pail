//
//  Tag+Convenience.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/6/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import CoreData

extension Tag {
    convenience init(title: String?,
                     colorNumber: Double,
                     context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        
        self.title = title
        self.colorNumber = colorNumber
    }
}
