//
//  ColorHelper.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/7/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import UIKit

struct ColorHelper {
    /// Returns a UI Color that corrosponds to a number (1.0 - 17.0).
    static func colorFrom(colorNumber: Double) -> UIColor {
        switch colorNumber {
        case 1.0:
            return UIColor.pumpkinOrange
        case 2.0:
            return UIColor.keyLimeGreen
        case 3.0:
            return UIColor.deepBlue
        case 4.0:
            return UIColor.maroonViolet
        case 5.0:
            return UIColor.lilacPurple
        case 6.0:
            return UIColor.brightRed
        case 7.0:
            return UIColor.redOrange
        case 8.0:
            return UIColor.yellowOrange
        case 9.0:
            return UIColor.yellow
        case 10.0:
            return UIColor.yellowGreen
        case 11.0:
            return UIColor.green
        case 12.0:
            return UIColor.teal
        case 13.0:
            return UIColor.skyBlue
        case 14.0:
            return UIColor.darkBlue
        case 15.0:
            return UIColor.violet
        case 16.0:
            return UIColor.redViolet
        case 17.0:
            return UIColor.pink
        default:
            return UIColor.black
        }
    }
}
