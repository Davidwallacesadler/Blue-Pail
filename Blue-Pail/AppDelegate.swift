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
    
    // MARK: - Properties

    var window: UIWindow?
    let defaults = UserDefaults()
    
    // MARK: - DidFinishLaunchingWithOptions

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        onFirstLaunch()
        setupNotificationActions()
        return true
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let plantId = userInfo[Keys.userInfoPlantUuid] as! String
        var plantAssociatedWithNotification : Plant?
        for plant in PlantController.shared.plants {
            if plant.uuid?.uuidString == plantId {
                plantAssociatedWithNotification = plant
                break
            }
        }
        switch response.actionIdentifier {
        case Keys.waterNotificationAction:
            // Waters the selected plant:
            if plantAssociatedWithNotification != nil {
                PlantController.shared.waterPlant(plant: plantAssociatedWithNotification!)
            }
            break
        case Keys.oneHourSnoozeNotificationAction:
            // Set Watered status of plant to true and set the next notification to be one hour from Date():
            if plantAssociatedWithNotification != nil {
                PlantController.shared.snoozeWateringFor(plant: plantAssociatedWithNotification!, hoursForSnooze: 1)
            }
            break
        case Keys.oneDaySnoozeNotificationAction:
            // Set Watered status of plant to true and set the next notification to be one day from Date():
            if plantAssociatedWithNotification != nil {
                PlantController.shared.snoozeWateringFor(plant: plantAssociatedWithNotification!, hoursForSnooze: 24)
            }
            break
        default:
            break
        }
        completionHandler()
    }
    
    // MARK: - First Launch Methods
    
    private func onFirstLaunch() {
        let firstLaunch = FirstLaunch(userDefaults: .standard, key: Keys.FirstLaunchKey)
        if firstLaunch.isFirstLaunch {
            CreateDataFactory.createData()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let onboardingViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingPageViewController") as! OnboardingPageViewController
            self.window?.rootViewController = onboardingViewController
            self.window?.makeKeyAndVisible()
            // UserDefaults Setup:
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

