//
//  Optional.swift
//  Blue-Pail
//
//  Created by David Sadler on 6/5/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation


extension Optional where Wrapped == String {
    /// Returns nil if the String is empty.
    var nilIfEmpty: String? {
        guard let strongSelf = self else {
            return nil
        }
        return strongSelf.isEmpty ? nil : strongSelf
    }
}
