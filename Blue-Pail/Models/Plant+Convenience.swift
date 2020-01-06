//
//  Plant+Convenience.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/6/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension Plant {
    
    // MARK: - Properties

    var photo: UIImage {
        // Make sure the image data is not nil:
        guard let image = image else { return UIImage(named: "default") ?? UIImage() }
        // Make sure we can create a UIImage out of the image data:
        guard let photo = UIImage(data: image as Data) else { return UIImage() }
        // Return the image UIImage:
        return photo
    }
    
    var fireTimeAsString: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .short
            return dateFormatter.string(from: needsWateredFireDate!)
        }
    }
    
    
    // MARK - Convenience Initializer
    
    // Note that isWatered defaults to true, needsWateredFireDate defaults to curent date
    convenience init(name: String?,
                     isWatered: Bool = true,
                     needsWateredFireDate: Date,
                     image: Data?,
                     uuid: UUID,
                     dayToNextWater: Int16,
                     daysToNextFertilize: Int16?,
                     isFertilized: Bool?,
                     needsFertilizedFireDate: Date?,
                     context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.isWatered = isWatered
        self.needsWateredFireDate = needsWateredFireDate
        self.image = image
        self.uuid = uuid
        self.dayToNextWater = dayToNextWater
        self.daysToNextFertilize = daysToNextFertilize ?? 0
        self.isFertilized = isFertilized ?? true
        self.needsFertilizedFireDate = needsFertilizedFireDate ?? Date()
    }
    
}
