//
//  FunctionHelpers.swift
//  Blue-Pail
//
//  Created by David Sadler on 7/6/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

#warning("put all helper methonds in this struct")
struct FunctionHelper {
    
    /// Returns the amount of days in the argument month. Takes leap years into account.
   static func getAmountOfDaysInCurrentMonth(givenMonthNumber month: Int, givenYearNumber year: Int) -> Int {
        let isLeapYear = ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0))
        var februaryDays = 28
        if isLeapYear == true {
            februaryDays = 29
        }
        switch month {
        case 1:
            return 31
        case 2:
            return februaryDays
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
}
