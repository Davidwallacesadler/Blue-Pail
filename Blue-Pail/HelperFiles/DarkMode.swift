//
//  DarkMode.swift
//  Blue-Pail
//
//  Created by David Sadler on 8/4/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

class DarkMode {
    static let shared = DarkMode()
    var isDarkMode = UserDefaults.standard.bool(forKey: Keys.themeMode)
}
