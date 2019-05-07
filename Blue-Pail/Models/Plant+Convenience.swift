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

// Extend Plant Object for convenience initializer:
extension Plant {
    
    // MARK: - Property

    var photo: UIImage {
        // Make sure the image data is not nil:
        guard let image = image else { return UIImage() }
        // Make sure we can create a UIImage out of the image data:
        guard let photo = UIImage(data: image as Data) else { return UIImage() }
        // Return the image UIImage:
        return photo
    }
    
    // MARK - Convenience Initializer
    
    convenience init(name: String?,
                     isWatered: Bool,
                     needsWateredFireDate: Date = Date(),
                     image: Data?,
                     context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        
        self.name = name
        self.isWatered = isWatered
        self.needsWateredFireDate = needsWateredFireDate
        self.image = image
    }
    
}
