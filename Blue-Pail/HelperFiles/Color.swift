//
//  Color.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/7/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

import UIKit

extension UIColor {
    
    // MARK: - Shot Buddy colors
    
    static var pumpkinOrange: UIColor {
        return UIColor(red: 247/255, green: 130/255, blue: 6/255, alpha: 1.0)
    }
    static var keyLimeGreen: UIColor {
        return UIColor(red: 199/255, green: 239/255, blue: 109/255, alpha: 1.0)
    }
    static var deepBlue: UIColor {
        return UIColor(red: 49/255, green: 75/255, blue: 224/255, alpha: 1.0)
    }
    static var maroonViolet: UIColor {
        return UIColor(red: 72/255, green: 15/255, blue: 33/255, alpha: 1.0)
    }
    static var lilacPurple: UIColor {
        return UIColor(red: 153/255, green: 153/255, blue: 1.0, alpha: 1.0)
    }
    static var brightRed: UIColor {
        return UIColor(red: 235/255, green: 25/255, blue: 50/255, alpha: 1.0)
    }
    
    // MARK: - Cell Colors (Water status indicator)
    
    static var wateredBlue: UIColor {
        return UIColor(red: 119/255, green: 157/255, blue: 192/255, alpha: 1.0)
    } // As of Version 1.02 Not using this blue as water indicator
    static var mintGreen: UIColor {
        return UIColor(red: 221/255, green: 248/255, blue: 244/255, alpha: 1.0)
    }
    static var dryRed: UIColor {
        return UIColor(red: 232/255, green: 25/255, blue: 32/255, alpha: 1.0)
    }
    static var fertilizerGreen: UIColor {
        return UIColor(red: 90/255, green: 150/255, blue: 60/255, alpha: 1.0)
    }
    static var defaultBlue: UIColor {
        return UIColor(red: 23/255, green: 81/255, blue: 255/255, alpha: 1.0)
    }
    
    // MARK: - Custom Tag Colors
    
    static var redOrange: UIColor {
        return UIColor(red: 229/255, green: 89/255, blue: 0/255, alpha: 1.0)
    }
    
    static var yellowOrange: UIColor {
        return UIColor(red: 229/255, green: 145/255, blue: 0/255, alpha: 1.0)
    }
    
    static var yellow: UIColor {
        return UIColor(red: 229/255, green: 193/255, blue: 0/255, alpha: 1.0)
    }
    
    static var yellowGreen: UIColor {
        return UIColor(red: 181/255, green: 229/255, blue: 0/255, alpha: 1.0)
    }
    
    static var green: UIColor {
        return UIColor(red: 100/255, green: 229/255, blue: 0/255, alpha: 1.0)
    }
    
    static var teal: UIColor {
        return UIColor(red: 1/255, green: 229/255, blue: 206/255, alpha: 1.0)
    }
    
    static var skyBlue: UIColor {
        return UIColor(red: 0/255, green: 160/255, blue: 229/255, alpha: 1.0)
    }
    
    static var darkBlue: UIColor {
        return UIColor(red: 0/255, green: 69/255, blue: 229/255, alpha: 1.0)
    }
    
    static var violet: UIColor {
        return UIColor(red: 27/255, green: 0/255, blue: 229/255, alpha: 1.0)
    }
    
    static var redViolet: UIColor {
        return UIColor(red: 125/255, green: 0/255, blue: 229/255, alpha: 1.0)
    }
    
    static var pink: UIColor {
        return UIColor(red: 229/255, green: 9/255, blue: 191/255, alpha: 1.0)
    }
    
    // MARK: - Text Colors
    
    static var pailBlue: UIColor {
        return UIColor(red: 0/255, green: 69/255, blue: 229/255, alpha: 1.0)
    }
    
    static var darkGrayBlue: UIColor {
        return UIColor(red: 58/255, green: 62/255, blue: 85/255, alpha: 1.0)
    } // This is used as the main text color
    
    // MARK: - TableView Colors
    #warning("Make all the colors for the color schemes named based on their use")
    
    static var tableViewSectionGray: UIColor {
        return UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
    }
    static var darkModeGray: UIColor {
        return UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
    }
    static var textFieldBackgroundGray: UIColor {
        return UIColor(red: 86/255, green: 92/255, blue: 128/255, alpha: 1.0)
    }
}
