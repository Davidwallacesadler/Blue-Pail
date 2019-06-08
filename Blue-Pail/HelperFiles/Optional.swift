//
//  Optional.swift
//  Blue-Pail
//
//  Created by David Sadler on 6/5/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

// This extension adds functionallity on optional Strings
extension Optional where Wrapped == String {
    /// Returns nil if the string is empty.
    var nilIfEmpty: String? {
        guard let strongSelf = self else {
            return nil
        }
        return strongSelf.isEmpty ? nil : strongSelf
    }
}
