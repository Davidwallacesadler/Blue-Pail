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
    
    func hourOfCurrentDate() -> Int {
        let calendar = Calendar.current
        let component = calendar.dateComponents([.hour], from: self)
        guard let hour = component.hour else { return 0  }
        return hour
    }
    
    func minuteOfCurrentDate() -> Int {
        let calendar = Calendar.current
        let component = calendar.dateComponents([.minute], from: self)
        guard let minute = component.minute else { return 0  }
        return minute
    }
}
