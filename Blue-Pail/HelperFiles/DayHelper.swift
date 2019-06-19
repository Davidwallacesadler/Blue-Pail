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
    
    /// Returns a date that is equivalent to an argument date plus an arguemnt number of days.
    static func futureDateFromADate(givenDate: Date, numberOfDays: Int) -> Date {
        let secondsInADay = 86400
        let selectedDaysInSeconds = Double(numberOfDays * secondsInADay)
        guard let timeIntervalFromSeconds = TimeInterval(exactly: selectedDaysInSeconds) else {
            return Date()
        }
        return Date(timeInterval: timeIntervalFromSeconds, since: givenDate)
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
    
    // TODO: - Fix Today and 1 Day disrepencies
    /// Returns a string representing how many days there are until the desired fireDate. Note: Call this only when the current date is less than the fireDate.
//    static func daysUntil(fireDate: Date) -> String {
//        let currentDate = Date()
//        let currentDateTimeInterval = currentDate.timeIntervalSinceReferenceDate
//        let futureDateTimeInterval = fireDate.timeIntervalSinceReferenceDate
//        let difference = futureDateTimeInterval - currentDateTimeInterval
//        let secondsInADay = 86400.0
//        let daysLeft = difference / secondsInADay
//        var daysLeftText = String(Int(daysLeft.rounded(.up)))
//        if twoDatesAreOnTheSameDay(dateOne: currentDate, dateTwo: fireDate) {
//            daysLeftText = "Today"
//        } else if daysLeft < 1.5 {
//            daysLeftText = "1 Day"
//        } else {
//            daysLeftText.append(" Days")
//        }
//        return daysLeftText
//    }
    
    static func amountOfDaysBetween(previousDate dateOne: Date, futureDate dateTwo: Date) -> String {
        // Helper:
        func getAmountOfDaysInCurrentMonth(givenMonthNumber month: Int, givenYearNumber year: Int) -> Int {
            let isLeapYear = ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0))
            var februraryDays = 28
            if isLeapYear == true {
                februraryDays = 29
            }
            switch month {
            case 1:
                return 31
            case 2:
                return februraryDays
            case 3:
                return 31
            case 4:
                return 30
            case 5:
                return 31
            case 6:
                return 30
            case 7:
                return 31
            case 8:
                return 30
            case 9:
                return 31
            case 10:
                return 31
            case 11:
                return 30
            case 12:
                return 31
            default:
                print("Defualting to 30 days this month -- dayHelper switch error")
                return 30
            }
        }
        var amountOfDaysBetween = Int()
        let calendar = Calendar.current
        let previousDateComponents = calendar.dateComponents([.year, .month, .day], from: dateOne)
        let futureDateComponents = calendar.dateComponents([.year, .month, .day], from: dateTwo)
        guard let previousDateYear = previousDateComponents.year, let previousDateMonth = previousDateComponents.month, let previousDateDay = previousDateComponents.day, let futureDateYear = futureDateComponents.year, let futureDateMonth = futureDateComponents.month, let futureDateDay = futureDateComponents.day else { return dateOne.dayMonthYearValue() }
        if previousDateYear == futureDateYear {
            if previousDateMonth == futureDateMonth {
                if previousDateDay == futureDateDay {
                    // Day, Month, Year are the same:
                    let timeOfFutureDate = dateTwo.timeStringValue()
                    return "Today(\(timeOfFutureDate))"
                } else {
                    // Month, Year are the same. day is different:
                    amountOfDaysBetween = futureDateDay - previousDateDay
                    if amountOfDaysBetween == 1 {
                        return "1 Day"
                    }
                    return "\(amountOfDaysBetween) Days"
                }
            } else {
                // Year is the same. Month, Day is different:
                let amountOfDaysInPreviousMonth = getAmountOfDaysInCurrentMonth(givenMonthNumber: previousDateMonth, givenYearNumber: previousDateYear)
                let daysUntilTheEndOfTheMonth = amountOfDaysInPreviousMonth - previousDateDay
                amountOfDaysBetween = futureDateDay + daysUntilTheEndOfTheMonth
                if amountOfDaysBetween == 1 {
                    return "1 Day"
                }
                return "\(amountOfDaysBetween) Days"
            }
        } else {
            // Year, Month, Day are different:
            let amountOfDaysInPreviousMonth = getAmountOfDaysInCurrentMonth(givenMonthNumber: previousDateMonth, givenYearNumber: previousDateYear)
            let daysUntilTheEndOfTheMonth = amountOfDaysInPreviousMonth - previousDateDay
            amountOfDaysBetween = futureDateDay + daysUntilTheEndOfTheMonth
            if amountOfDaysBetween == 1 {
                return "1 Day"
            }
            return "\(amountOfDaysBetween) Days"
        }
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
            formattedDate.append("JAN ")
        case 02:
            formattedDate.append("FEB ")
        case 03:
            formattedDate.append("MAR ")
        case 04:
            formattedDate.append("APR ")
        case 05:
            formattedDate.append("MAY ")
        case 06:
            formattedDate.append("JUN ")
        case 07:
            formattedDate.append("JUL ")
        case 08:
            formattedDate.append("AUG ")
        case 09:
            formattedDate.append("SEP ")
        case 10:
            formattedDate.append("OCT ")
        case 11:
            formattedDate.append("NOV ")
        case 12:
            formattedDate.append("DEC ")
        default:
            print("ERROR: FormatDayAndMonth method switch statment failed - defualting to January")
            formattedDate.append("JAN ")
        }
        let formattedDay = formatDayDigit(givenDay: currentDayNumber)
        formattedDate.append(formattedDay)
        return formattedDate
    }
    
    ///Returns the desired hour/minute on todays date given the hour and minute values.
    static func getCorrectTimeToday(desiredHourMinute: (Int, Int)) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        let correctHour = desiredHourMinute.0
        let correctMinute = desiredHourMinute.1
        components.hour = correctHour
        components.minute = correctMinute
        guard let todayAtTheCorrectTime = calendar.date(from: components) else {
            print("getCorrectTimeToday: Error instantiating date from components - returning Date()")
            return Date()
        }
        return todayAtTheCorrectTime
    }
    
    // TODO: - Replace getCorrectTimeToday with getSameTimeAsDateToday
    ///Returns the desired hour/minute on todays date that matches the target dates hour/minute.
    static func getSameTimeAsDateToday(targetDate date: Date) -> Date {
        let calendar = Calendar.current
        let desiredComponents = calendar.dateComponents([.hour, .minute], from: date)
        var todaysComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        guard let correctHour = desiredComponents.hour, let correctMinute = desiredComponents.minute else {
            print("GetSameTimeAsDateToday: Error grabbing date components - returning Date()")
            return Date()
        }
        todaysComponents.hour = correctHour
        todaysComponents.minute = correctMinute
        todaysComponents.second = 0
        guard let todayAtCorrectTime = calendar.date(from: todaysComponents) else {
            print("GetSameTimeAsDateToday: Error instantiating date from components - returning Date()")
            return Date()
        }
        return todayAtCorrectTime
    }
    
    /// MARK: Internal Methods
    
    
    
}
