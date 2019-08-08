//
//  ViewHelper.swift
//  Blue-Pail
//
//  Created by David Sadler on 7/29/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import UIKit

struct ViewHelper {
    
    /// Rounds the corners of the CALayer of the desired view based on the rounding number passed in. The larger the number the more the corners are rounded.
    static func roundCornersOf(viewLayer: CALayer,withRoundingCoefficient rounding: Double) {
        viewLayer.cornerRadius = CGFloat(rounding)
        viewLayer.borderWidth = 1.0
        viewLayer.borderColor = UIColor.clear.cgColor
        viewLayer.masksToBounds = true
    }
    
}
