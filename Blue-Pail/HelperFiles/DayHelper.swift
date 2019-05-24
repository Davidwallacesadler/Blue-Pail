//
//  DayHelper.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/17/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

struct DayHelper {

    // MARK: - Methods
    
    /// Returns a date that is equivalent to today's date plus the argument number of days.
    static func futrueDateFrom(givenNumberOfDays days: Int) -> Date {
        // => 60 sec/min  * 60 min/hour * 24 hour/day = 86400 sec/day
        let secondsInADay = 86400
        let selectedDaysInSeconds = Double(days * secondsInADay)
        guard let timeIntervalFromSeconds = TimeInterval(exactly: selectedDaysInSeconds) else {
            return Date()
        }
        return Date(timeInterval: timeIntervalFromSeconds, since: Date())
        
    }
    
    /// Returns true if the two passed in dates are on the same day:
    static func twoDatesAreOnTheSameDay(dateOne: Date, dateTwo: Date) -> Bool {
        let calendar = Calendar.current
        let dateOneComponent = calendar.dateComponents([.day], from: dateOne)
        let dateTwoComponent = calendar.dateComponents([.day], from: dateTwo)
        if dateOneComponent.day == dateTwoComponent.day {
            return true
        } else {
            return false
        }
    }
    
    /// Returns a string representing how many days there are until the desired fireDate. Note: Call this only when the current date is less than the fireDate.
    static func daysUntil(fireDate: Date) -> String {
        let currentDate = Date()
        let currentDateTimeInterval = currentDate.timeIntervalSinceReferenceDate
        let futureDateTimeInterval = fireDate.timeIntervalSinceReferenceDate
        let difference = futureDateTimeInterval - currentDateTimeInterval
        let secondsInADay = 86400.0
        let daysLeft = difference / secondsInADay
        var daysLeftText = String(Int(daysLeft.rounded(.up)))
        if twoDatesAreOnTheSameDay(dateOne: currentDate, dateTwo: fireDate) {
            daysLeftText = "Today"
        } else if daysLeft <= 1.0 {
            daysLeftText.append(" day")
        } else {
            daysLeftText.append(" Days")
        }
        return daysLeftText
    }
    
    /// Returns a "month day" abbreviation of the argument date. I.E If the argument date is in january 10 2019, then the return string will be "Jan 10th".
    static func formatMonthAndDay(givenDate: Date) -> String {
     
        /// Returns the proper suffix for a day. I.E 11 => "11th", 21 => "21st".
        func formatDayDigit(givenDay day: Int) -> String {
            var formatted = String()
            formatted.append("\(day)")
            var tenCount = 0
            var digit = day
            while digit > 10 {
                digit = digit - 10
                tenCount += 1
            }
            if tenCount == 1 {
                formatted.append("th")
            } else {
                switch digit {
                case 1:
                    formatted.append("st")
                case 2:
                    formatted.append("nd")
                case 3:
                    formatted.append("rd")
                default:
                    formatted.append("th")
                }
            }
            return formatted
        }
        
        var formattedDate = String()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: givenDate)
        guard let currentMonthNumber = components.month, let currentDayNumber = components.day else {
            print("ERROR: formatMonthAndDay failed to get month and day components - Default date returned")
            return "Jan 1st"
            
        }
        switch currentMonthNumber {
        case 01:
            formattedDate.append("Jan ")
        case 02:
            formattedDate.append("Feb ")
        case 03:
            formattedDate.append("Mar ")
        case 04:
            formattedDate.append("Apr ")
        case 05:
            formattedDate.append("May ")
        case 06:
            formattedDate.append("Jun ")
        case 07:
            formattedDate.append("Jul ")
        case 08:
            formattedDate.append("Aug ")
        case 09:
            formattedDate.append("Sep ")
        case 10:
            formattedDate.append("Oct ")
        case 11:
            formattedDate.append("Nov ")
        case 12:
            formattedDate.append("Dec ")
        default:
            print("ERROR: FormatDayAndMonth method switch statment failed - defualting to January")
            formattedDate.append("Jan ")
        }
        let formattedDay = formatDayDigit(givenDay: currentDayNumber)
        formattedDate.append(formattedDay)
        return formattedDate
    }
}
