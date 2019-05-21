//
//  DayHelper.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/17/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

struct DayHelper {
    
    /// Returns a time interval that is equivalent to the number of days passed in.
    static func timeIntervalFrom(dayIntegerCount days: Int) -> TimeInterval {
        // => 60 sec/min  * 60 min/hour * 24 hour/day
        let secondsInADay = 86400
        let selectedDaysInSeconds = Double(days * secondsInADay)
        guard let timeIntervalFromSeconds = TimeInterval(exactly: selectedDaysInSeconds) else {
            return TimeInterval()
        }
        return timeIntervalFromSeconds
        
    }
    /// Returns a future date that is equivalent to the current date plus a given number of days away (s.t the given number of days is from 1 to 31).
    static func futureDateFromToday(givenNumberOfDays days: Int) -> Date {
        let todaysDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: todaysDate)
        guard let todaysYear = components.year, let todaysMonth = components.month,  let todaysDay = components.day, let todaysHour = components.hour, let todaysMinute = components.minute else { return Date() }
        let futureDayValue = todaysDay + days
        var futureDay = Int()
        var futureMonth = Int()
        var futureYear = Int()
        var monthLength = Int()
        switch todaysMonth {
        case 1, 3, 5, 7, 8, 10:
            // Months that have 31 days
            monthLength = 31
            if futureDayValue > monthLength {
                // increase month by one and get rid of extra days
                futureMonth = todaysMonth + 1
                futureDay = futureDayValue - monthLength
                futureYear = todaysYear
            } else {
                // We are inside the month so just increase the day value
                futureDay = futureDayValue
                futureMonth = todaysMonth
                futureYear = todaysYear
            }
        case 2:
            // Month has 28 days by default -- check if the year is a leap year
            if todaysYear == 2020 {
                monthLength = 29
            } else {
                monthLength = 28
            }
            if futureDayValue > monthLength {
                // increase month by one and get rid of extra days
                futureMonth = todaysMonth + 1
                futureDay = futureDayValue - monthLength
                futureYear = todaysYear
            } else {
                // We are inside the month so just increase the day value
                futureDay = futureDayValue
                futureMonth = todaysMonth
                futureYear = todaysYear
            }
        case 4, 6, 9, 11:
            // Months with 30 days
            monthLength = 30
            if futureDayValue > monthLength {
                // increase month by one and get rid of extra days
                futureMonth = todaysMonth + 1
                futureDay = futureDayValue - monthLength
                futureYear = todaysYear
            } else {
                // We are inside the month so just increase the day value
                futureDay = futureDayValue
                futureMonth = todaysMonth
                futureYear = todaysYear
            }
        case 12:
            monthLength = 31
            if futureDayValue > monthLength {
                // set month to one, increase year by one, and get rid of extra days
                futureMonth = 1
                futureDay = futureDayValue - monthLength
                futureYear = todaysYear + 1
            } else {
                // We are inside the month so just increase the day value
                futureDay = futureDayValue
                futureMonth = todaysMonth
                futureYear = todaysYear
            }
        default:
            futureDay = futureDayValue
            futureMonth = todaysMonth
            futureYear = todaysYear
        }
        
        // Have everything we need to create the date
        var newDateString = ""
        newDateString.append("\(futureYear)-")
        if futureMonth < 10 {
            newDateString.append("0")
        }
        newDateString.append("\(futureMonth)-")
        if futureDay < 10 {
            newDateString.append("0")
        }
        newDateString.append("\(futureDay)")
        if todaysHour < 10 {
            newDateString.append("0")
        }
        // ACCOUNT FOR UTC -- find a better way of accounting for this because its different based on the currentTimeZone
        //newDateString.append(" \(todaysHour - 6):")
        newDateString.append(" \(todaysHour):")
        newDateString.append("\(todaysMinute):")
        // Round the minute off
        newDateString.append("00")
        
        // Format the date:
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // Create the date from the string:
        
        guard let desintationDate = formatter.date(from: newDateString) else {
            print("Error instantiating new date from date string - returning current date")
            return Date()
        }
        return desintationDate
    }
}
