//
//  Date.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/27/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

extension Date {
    func stringValue() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
    
    func timeStringValue() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: self)
    }
    
    func dayMonthYearValue() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short    
        return formatter.string(from: self)
    }
}
