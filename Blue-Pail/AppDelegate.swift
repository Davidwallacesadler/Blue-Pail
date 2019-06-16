//
//  AppDelegate.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/6/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: - Notifications
        
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        center.requestAuthorization(options: options) {
            (accepted, error) in
            if !accepted {
                print("Notification access has been denied")
            }
        }
        UNUserNotificationCenter.current().delegate = self
        
        // MARK: - For First Launch Testing Tag data
        //alwaysFirstLaunch()
        onFirstLaunch()
        
        return true
    }
    
    // MARK: - First Launch Methods
    
    // CHECK IF THESE ARE PROPERLY CONFIGURED
    private func onFirstLaunch() {
        let firstLaunch = FirstLaunch(userDefaults: .standard, key: Keys.FirstLaunchKey)
        if firstLaunch.isFirstLaunch {
            CreateDataFactory.createData()
        }
    }
    // CHECK WITH COLTON ABOUT THIS
//    private func alwaysFirstLaunch() {
//        let alwaysFirstLaunch = FirstLaunch.alwaysFirst()
//    }
    
    // MARK: userNotifcationCenter willPresentNotification
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
         UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
}

