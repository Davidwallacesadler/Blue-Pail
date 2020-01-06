//
//  Date.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/27/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

extension Date {
    
    /// Returns a String with a short time and date style (i.e "MM/DD/YYYY, HH:MM AM/PM").
    func stringValue() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
    
    /// Returns a String with just the short time style (i.e "HH:MM AM/PM").
    func timeStringValue() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: self)
    }
    
    /// Returns a string with just the short date style (i.e "MM/DD/YYYY").
    func dayMonthYearValue() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short    
        return formatter.string(from: self)
    }
    
    /// Returns an Integer representing the hour value of the date.
    func hourOfCurrentDate() -> Int {
        let calendar = Calendar.current
        let component = calendar.dateComponents([.hour], from: self)
        guard let hour = component.hour else { return 0  }
        return hour
    }
    
    /// Returns an Integer representing the minute value of the date.
    func minuteOfCurrentDate() -> Int {
        let calendar = Calendar.current
        let component = calendar.dateComponents([.minute], from: self)
        guard let minute = component.minute else { return 0  }
        return minute
    }
    
    func dayOfCurrentDate() -> Int {
        let calendar = Calendar.current
        let component = calendar.dateComponents([.day], from: self)
        guard let day = component.day else { return 0 }
        return day
    }
    
    func dayMonthYearInts() -> [Int] {
        let calendar = Calendar.current
        let component = calendar.dateComponents([.day,.month,.year], from: self)
        guard let day = component.day, let month = component.month, let year = component.year else { return [] }
        return [day,month,year]
    }
}
