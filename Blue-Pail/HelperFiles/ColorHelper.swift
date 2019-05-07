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
        default:
            return UIColor.black
        }
    }
}
