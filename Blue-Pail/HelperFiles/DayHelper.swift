//
//  DayHelper.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/17/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

struct DayHelper {
    
    // MARK: - Shared Instance (singleton)
    
    static let shared = DayHelper()

    // MARK: - Methods
  
    
    
    /// Returns a date that is equivalent to today's date plus the argument number of days.
    func futrueDateFrom(givenNumberOfDays days: Int) -> Date {
        let secondsInADay = 86400
        let selectedDaysInSeconds = Double(days * secondsInADay)
        guard let timeIntervalFromSeconds = TimeInterval(exactly: selectedDaysInSeconds) else {
            return Date()
        }
        return Date(timeInterval: timeIntervalFromSeconds, since: Date())
    }
    
    /// Returns a date that is equivalent to an argument date plus an arguemnt number of days.
    func futureDateFromADate(givenDate: Date, numberOfDays: Int) -> Date {
        let secondsInADay = 86400
        let selectedDaysInSeconds = Double(numberOfDays * secondsInADay)
        guard let timeIntervalFromSeconds = TimeInterval(exactly: selectedDaysInSeconds) else {
            return Date()
        }
        return Date(timeInterval: timeIntervalFromSeconds, since: givenDate)
    }
    
    /// Returns true if the two passed in dates are on the same day:
    func twoDatesAreOnTheSameDay(dateOne: Date, dateTwo: Date) -> Bool {
        let calendar = Calendar.current
        let dateOneComponent = calendar.dateComponents([.day], from: dateOne)
        let dateTwoComponent = calendar.dateComponents([.day], from: dateTwo)
        if dateOneComponent.day == dateTwoComponent.day {
            return true
        } else {
            return false
        }
    }
    
    /// Returns a string representing how many days there are until the desired fireDate. Note: This makes the most sense to only call when dateOne <= dateTwo.
    #warning("clean up the logic at the end this method")
    func amountOfDaysBetween(previousDate dateOne: Date, futureDate dateTwo: Date) -> String {
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
                        return "Tomorrow(\(dateTwo.timeStringValue()))"
                    }
                    return "\(amountOfDaysBetween) Days"
                }
            } else {
                // Year is the same. Month, Day is different:
                let amountOfDaysInPreviousMonth = FunctionHelper.getAmountOfDaysInCurrentMonth(givenMonthNumber: previousDateMonth, givenYearNumber: previousDateYear)
                let daysUntilTheEndOfTheMonth = amountOfDaysInPreviousMonth - previousDateDay
                amountOfDaysBetween = futureDateDay + daysUntilTheEndOfTheMonth
                if amountOfDaysBetween == 1 {
                    return "Tomorrow(\(dateTwo.timeStringValue()))"
                }
                return "\(amountOfDaysBetween) Days"
            }
        } else {
            // Year, Month, Day are different:
            let amountOfDaysInPreviousMonth = FunctionHelper.getAmountOfDaysInCurrentMonth(givenMonthNumber: previousDateMonth, givenYearNumber: previousDateYear)
            let daysUntilTheEndOfTheMonth = amountOfDaysInPreviousMonth - previousDateDay
            amountOfDaysBetween = futureDateDay + daysUntilTheEndOfTheMonth
            if amountOfDaysBetween == 1 {
                return "Tomorrow(\(dateTwo.timeStringValue()))"
            }
            return "\(amountOfDaysBetween) Days"
        }
    }
    
    func amountOfDaysBetweenInteger(previousDate dateOne: Date, futureDate dateTwo: Date) -> Int? {
        var amountOfDaysBetween = Int()
        let calendar = Calendar.current
        let previousDateComponents = calendar.dateComponents([.year, .month, .day], from: dateOne)
        let futureDateComponents = calendar.dateComponents([.year, .month, .day], from: dateTwo)
        guard let previousDateYear = previousDateComponents.year, let previousDateMonth = previousDateComponents.month, let previousDateDay = previousDateComponents.day, let futureDateYear = futureDateComponents.year, let futureDateMonth = futureDateComponents.month, let futureDateDay = futureDateComponents.day else { return nil }
        if previousDateYear == futureDateYear {
            if previousDateMonth == futureDateMonth {
                if previousDateDay == futureDateDay {
                    // Day, Month, Year are the same:
                    let timeOfFutureDate = dateTwo.timeStringValue()
                    return 1
                } else {
                    // Month, Year are the same. day is different:
                    amountOfDaysBetween = futureDateDay - previousDateDay
                    return amountOfDaysBetween
                }
            } else {
                // Year is the same. Month, Day is different:
                let amountOfDaysInPreviousMonth = FunctionHelper.getAmountOfDaysInCurrentMonth(givenMonthNumber: previousDateMonth, givenYearNumber: previousDateYear)
                let daysUntilTheEndOfTheMonth = amountOfDaysInPreviousMonth - previousDateDay
                amountOfDaysBetween = futureDateDay + daysUntilTheEndOfTheMonth
                return amountOfDaysBetween
            }
        } else {
            // Year, Month, Day are different:
            let amountOfDaysInPreviousMonth = FunctionHelper.getAmountOfDaysInCurrentMonth(givenMonthNumber: previousDateMonth, givenYearNumber: previousDateYear)
            let daysUntilTheEndOfTheMonth = amountOfDaysInPreviousMonth - previousDateDay
            amountOfDaysBetween = futureDateDay + daysUntilTheEndOfTheMonth
            return amountOfDaysBetween
        }
    }
    
    /// Returns a "month day" abbreviation of the argument date. I.E If the argument date is in january 10 2019, then the return string will be "Jan. 10th". Also if the argument date is yesterday (based on Date()) then the return string will be "Yesterday".
    func formatMonthAndDay(givenDate: Date) -> String {
     
        // FormatMonthAndDay Helper:
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
        let todaysComponents = calendar.dateComponents([.month,.day], from: Date())
        guard let currentMonthNumber = components.month, let currentDayNumber = components.day, let todaysMonthNumber = todaysComponents.month, let todaysDayNumber = todaysComponents.day else {
            print("ERROR: formatMonthAndDay failed to get month and day components - Default date returned")
            return givenDate.dayMonthYearValue()
        }
        // Check if given date is yesterday: -- improve this check to work at the end of the month
        if givenDate < Date() {
            if todaysMonthNumber == currentMonthNumber {
                if todaysDayNumber == todaysDayNumber + 1 {
                    return "Yesterday"
                }
            }
        }
        switch currentMonthNumber {
        case 01:
            formattedDate.append("Jan. ")
        case 02:
            formattedDate.append("Feb. ")
        case 03:
            formattedDate.append("Mar. ")
        case 04:
            formattedDate.append("Apr. ")
        case 05:
            formattedDate.append("May ")
        case 06:
            formattedDate.append("Jun. ")
        case 07:
            formattedDate.append("Jul. ")
        case 08:
            formattedDate.append("Aug. ")
        case 09:
            formattedDate.append("Sep. ")
        case 10:
            formattedDate.append("Oct. ")
        case 11:
            formattedDate.append("Nov. ")
        case 12:
            formattedDate.append("Dec. ")
        default:
            print("ERROR: FormatDayAndMonth method switch statment failed - defualting to January")
            formattedDate.append("Jan. ")
        }
        let formattedDay = formatDayDigit(givenDay: currentDayNumber)
        formattedDate.append(formattedDay)
        return formattedDate
    }
    
    ///Returns the desired hour/minute on todays date given the hour and minute values.
    func getCorrectTimeToday(desiredHourMinute: (Int, Int)) -> Date {
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
    
    func getCorrectTimeOnDate(desiredHourMinuteDate: Date, date: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let desiredCompnents = calendar.dateComponents([.hour, .minute], from: desiredHourMinuteDate)
        let correctHour = desiredCompnents.hour!
        let correctMinute = desiredCompnents.minute!
        components.hour = correctHour
        components.minute = correctMinute
        guard let dateAtTheCorrectTime = calendar.date(from: components) else {
            print("getCorrectTimeToday: Error instantiating date from components - returning Date()")
            return Date()
        }
        return dateAtTheCorrectTime
    }
    
    ///Returns the desired hour/minute on todays date that matches the target dates hour/minute.
    func getSameTimeAsDateToday(targetDate date: Date) -> Date {
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
    
    ///Returns the desired hour/minute on todays date that matches the target dates hour/minute.
    func getSameTimeAsDateTodayGivenDesired(FireDatehour: Int,targetDate date: Date) -> Date {
        let calendar = Calendar.current
        let desiredComponents = calendar.dateComponents([.hour, .minute], from: date)
        var todaysComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        guard let correctMinute = desiredComponents.minute else {
            print("GetSameTimeAsDateToday: Error grabbing date components - returning Date()")
            return Date()
        }
        todaysComponents.hour = FireDatehour
        todaysComponents.minute = correctMinute
        todaysComponents.second = 0
        guard let todayAtCorrectTime = calendar.date(from: todaysComponents) else {
            print("GetSameTimeAsDateToday: Error instantiating date from components - returning Date()")
            return Date()
        }
        return todayAtCorrectTime
    }
    
     ///Returns the desired hour/minute on todays date that matches the target dates hour/minute plus an amount of hours (used for snoozing the watering of a plant for a number of hours)
    func getSameTimeAsDateTodayPlusSomeHours(targetDate date: Date, givenAmountOfHours: Int) -> Date {
        let calendar = Calendar.current
        let desiredComponents = calendar.dateComponents([.hour, .minute], from: date)
        var todaysComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        guard let correctHour = desiredComponents.hour, let correctMinute = desiredComponents.minute else {
            print("GetSameTimeAsDateToday: Error grabbing date components - returning Date()")
            return Date()
        }
        todaysComponents.hour = correctHour + givenAmountOfHours
        // WHAT IF THE HOUR IS OVER 24? -- creating a date from a component with more than 24 hours will move onto the next day.
        todaysComponents.minute = correctMinute
        todaysComponents.second = 0
        guard let todayAtCorrectTime = calendar.date(from: todaysComponents) else {
            print("GetSameTimeAsDateToday: Error instantiating date from components - returning Date()")
            return Date()
        }
        return todayAtCorrectTime
    }
    
    func determineReadableIntervalBetweenDates(dateOne: Date, dateTwo: Date) -> String {
        var secondsFromNowTillEnd = dateTwo.timeIntervalSince(dateOne)
        let secondsInADay = 86400.0
        var intervalDays = 1
        while secondsFromNowTillEnd > secondsInADay {
            intervalDays += 1
            secondsFromNowTillEnd -= secondsInADay
        }
        var intervalWeeks = 0
        while intervalDays >= 7 {
            intervalWeeks += 1
            intervalDays -= 7
        }
        var text = ""
        if intervalWeeks != 0 {
            if intervalWeeks == 1 {
                text.append("1 week ")
            } else {
                text.append("\(intervalWeeks) weeks ")
            }
        }
        if intervalDays != 0 {
            if intervalDays == 1 {
                text.append("1 day")
            } else {
                text.append("\(intervalDays) days")
            }
        }
        return text
    }
    
    func translateDayIntToWeeks(givenAmountOfDays days: Int) -> String {
        var currentAmountOfDays = days
        var weekCount = 0
        var text = ""
        while currentAmountOfDays >= 7 {
            currentAmountOfDays -= 7
            weekCount += 1
        }
        if weekCount != 0 {
            if weekCount == 1 {
                text.append("1 week ")
            } else {
                text.append("\(weekCount) weeks ")
            }
        }
        if currentAmountOfDays != 0 {
            if currentAmountOfDays == 1 {
                text.append("1 day")
            } else {
                text.append("\(currentAmountOfDays) days")
            }
        }
        return text
    }
    
}
