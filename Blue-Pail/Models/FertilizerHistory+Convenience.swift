//
//  FertilizerHistory+Convenience.swift
//  Blue-Pail
//
//  Created by David Sadler on 12/27/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import CoreData

extension FertilizerHistory {
    convenience init(occurenceDate: Date,
                     context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.occurenceDate = occurenceDate
    }
}
