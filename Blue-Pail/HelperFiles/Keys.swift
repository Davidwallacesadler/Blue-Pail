//
//  Keys.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/17/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

enum Keys {
    
    // MARK: - UserDefaults FirstLaunchKey
    
    static let FirstLaunchKey = "FirstLaunch"
    
    // MARK: - UserDefaults
    
//    static let automaticWatering = "automaticWatering"
    static let themeMode = "themeMode"
    
    // MARK: - Image Names
    #warning("fix the names with the -1 suffix")
    
    // For Collection View Cell Icons:
    static let plantIcon = "plantNameIcon-1"
    static let clockIcon = "notTimeToWaterIcon"
    static let tagIcon = "tagNameIcon-1"
    static let wateringPailIcon = "waterPlantIcon-1"
    // For Buttons:
    static let filterButton = "filterButton"
    static let boxedMinusButton = "minusButton"
    static let boxedPlusButton = "plusButton"
    static let thinPlusButton = "thinPlusButton"
    static let boxedXButton = "xButton"
    static let cameraButton = "photoButton-1"
    // For Views:
    static let whiteShapeWithRoundedBottomCorners = "editButtonBackground"
    static let noImage = "default"
    // For Setting Icons:
    static let wateringModelIcon = "wateringModelIcon"
    static let darkModeIcon = "darkModeSettingIcon"
    static let viewTutorialIcon = "tutorialIcon"
    static let FAQIcon = "frequentlyAskedIcon"
    static let shareIcon = "shareIcon"
    static let rateIcon = "rateIcon"
    
    // MARK: - Video Names
    
    static let createAPlantTutorialVideo = "CreateAPlant"
    static let createATagTutorialVideo = "CreateATag"
    static let waterPlantTutorialVideo = "WaterPlant"
    
    // MARK: - Notification Keys:
    static let userInfoPlantUuid = "plantUuid"
    static let userInfoTagTitle = "associatedTagTitle"
    static let plantNotificationCatagoryIdentifier = "plantWateringNotification"
    static let waterNotificationAction = "waterPlant"
    static let oneHourSnoozeNotificationAction = "oneHourSnooze"
    static let oneDaySnoozeNotificationAction = "oneDaySnooze"
    
    
    
    
   
    
}
