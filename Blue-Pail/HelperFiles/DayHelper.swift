//
//  DayHelper.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/17/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

struct DayHelper {
    static func timeIntervalFrom(dayIntegerCount days: Int) -> TimeInterval {
        let secondsInADay = 86400
        let selectedDaysInSeconds = Double(days * secondsInADay)
        guard let timeIntervalFromSeconds = TimeInterval(exactly: selectedDaysInSeconds) else {
            return TimeInterval()
        }
        return timeIntervalFromSeconds
        
    }
}
