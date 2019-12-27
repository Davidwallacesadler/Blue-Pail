//
//  NavigationBarAndTabBarHelper.swift
//  Blue-Pail
//
//  Created by David Sadler on 7/24/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import UIKit


struct NavigationBarHelper {
    /// Changes the font and text color of the navigation bar title for the argument viewController.
    #warning("Change this to setupLightModeNavBar")
    static func setupNativationBar(viewController: UIViewController) {
        viewController.navigationController?.navigationBar.barTintColor = UIColor.mintGreen
        viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGrayBlue, NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 18)!]
    }
    
    static func setupDarkModeNavigationBar(viewController: UIViewController) {
        viewController.navigationController?.navigationBar.barTintColor = .darkModeGray
        viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 18)!]
    }
}
