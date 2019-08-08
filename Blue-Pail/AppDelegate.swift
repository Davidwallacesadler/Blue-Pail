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
    let defaults = UserDefaults()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //alwaysFirstLaunch()
        onFirstLaunch()
        setupNotificationActions()
        return true
    }
    
    // MARK: - First Launch Methods
    
    // CHECK IF THESE ARE PROPERLY CONFIGURED
    private func onFirstLaunch() {
        let firstLaunch = FirstLaunch(userDefaults: .standard, key: Keys.FirstLaunchKey)
        if firstLaunch.isFirstLaunch {
            CreateDataFactory.createData()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let onboardingViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingPageViewController") as! OnboardingPageViewController
            self.window?.rootViewController = onboardingViewController
            self.window?.makeKeyAndVisible()
            
            // UserDefaults Setup:
            //UserDefaults.standard.set(false, forKey: Keys.automaticWatering)
            UserDefaults.standard.set(false, forKey: Keys.themeMode)
        }
    }
    
    // MARK: - Notifcation Action Setup
    private func setupNotificationActions() {
        let waterAction = UNNotificationAction(identifier: Keys.waterNotificationAction, title: "Water Plant", options: UNNotificationActionOptions(rawValue: 0))
        let oneHourSnoozeAction = UNNotificationAction(identifier: Keys.oneHourSnoozeNotificationAction, title: "One Hour Snooze", options: UNNotificationActionOptions(rawValue: 0))
        let oneDaySnoozeAction = UNNotificationAction(identifier: Keys.oneDaySnoozeNotificationAction, title: "One Day Snooze", options: UNNotificationActionOptions(rawValue: 0))
        let plantWateringCatagory = UNNotificationCategory(identifier: Keys.plantNotificationCatagoryIdentifier, actions: [waterAction, oneHourSnoozeAction, oneDaySnoozeAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([plantWateringCatagory])
    }
    
    // MARK: userNotifcationCenter willPresentNotification
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}

