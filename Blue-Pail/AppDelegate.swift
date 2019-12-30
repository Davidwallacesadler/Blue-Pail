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
        #warning("replace this for loop with a NSFetchRequest with a predicate string == 'uuid == plantId'")
        var plantAssociatedWithNotification : Plant?
        for plant in PlantController.shared.plants {
            if plant.uuid?.uuidString == plantId {
                plantAssociatedWithNotification = plant
                break
            }
        }
        if let plant = plantAssociatedWithNotification {
            switch response.actionIdentifier {
            case Keys.waterNotificationAction:
                PlantController.shared.waterPlant(plant: plant)
                break
            case Keys.fertilizePlantNotificationAction:
                PlantController.shared.fertilizePlant(plant: plant)
                break
            case Keys.oneHourSnoozeNotificationAction:
                if userInfo[Keys.userInfoFertilizerSnooze] != nil {
                    PlantController.shared.snoozeWateringFor(plant: plant,
                                                             hoursForSnooze: 1,
                                                             givenNotificationName: Keys.fertilizerNotification)
                } else {
                    PlantController.shared.snoozeWateringFor(plant: plant,
                                                             hoursForSnooze: 1,
                                                             givenNotificationName: Keys.waterNotification)
                }
                break
            case Keys.oneDaySnoozeNotificationAction:
                if userInfo[Keys.userInfoFertilizerSnooze] != nil {
                    PlantController.shared.snoozeWateringFor(plant: plant,
                                                             hoursForSnooze: 24,
                                                             givenNotificationName: Keys.fertilizerNotification)
                }
                PlantController.shared.snoozeWateringFor(plant: plant,
                                                         hoursForSnooze: 24,
                                                         givenNotificationName: Keys.waterNotification)
                break
            default:
                break
            }
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
        let waterAction = UNNotificationAction(identifier: Keys.waterNotificationAction,
                                               title: "Water Plant",
                                               options: UNNotificationActionOptions(rawValue: 0))
        let oneHourSnoozeAction = UNNotificationAction(identifier: Keys.oneHourSnoozeNotificationAction,
                                                       title: "One Hour Snooze",
                                                       options: UNNotificationActionOptions(rawValue: 0))
        let oneDaySnoozeAction = UNNotificationAction(identifier: Keys.oneDaySnoozeNotificationAction,
                                                      title: "One Day Snooze",
                                                      options: UNNotificationActionOptions(rawValue: 0))
        let plantWateringCatagory = UNNotificationCategory(identifier: Keys.waterNotificationCatagoryIdentifier,
                                                           actions: [waterAction, oneHourSnoozeAction, oneDaySnoozeAction],
                                                           intentIdentifiers: [],
                                                           hiddenPreviewsBodyPlaceholder: "",
                                                           options: .customDismissAction)
        let fertilizeAction = UNNotificationAction(identifier: Keys.fertilizePlantNotificationAction,
                                                   title: "Fertilize Plant",
                                                   options: UNNotificationActionOptions(rawValue: 0))
        let plantFertilizingCatagory = UNNotificationCategory(identifier: Keys.fertilizePlantNotificationAction,
                                                              actions: [fertilizeAction, oneHourSnoozeAction, oneDaySnoozeAction],
                                                              intentIdentifiers: [],
                                                              hiddenPreviewsBodyPlaceholder: "",
                                                              options: .customDismissAction)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([plantWateringCatagory, plantFertilizingCatagory])
    }
    
    // MARK: userNotifcationCenter willPresentNotification
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}

