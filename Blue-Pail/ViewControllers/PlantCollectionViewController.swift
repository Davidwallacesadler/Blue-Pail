//
//  PlantCollectionViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/7/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit
import UserNotifications

private let reuseIdentifier = "plantCell"

class PlantCollectionViewController: UICollectionViewController, PopupDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CollectionViewCellLongTouchDelegate {
    
    
    func didLongPress(index: IndexPath) {
        let selectedPlant = plantCollection[index.row]
        PlantController.shared.waterPlant(plant: selectedPlant)
        self.collectionView.reloadItems(at: [index])
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        if areAllPlantsWatered() {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
        animateConfirmationImageView(notificationKey: Keys.waterNotification)
    }
    
    // MARK: - PickerView Delegate Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tagTitles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if tagTitles.isEmpty == false {
            let tagTitle = tagTitles[row]
            let tag = TagController.shared.getSelectedTag(givenTagTitle: tagTitle)
            var title = NSAttributedString(string: tagTitle, attributes: [NSAttributedString.Key.foregroundColor: ColorHelper.colorFrom(colorNumber: tag.colorNumber)])
            if row == 0 {
                if self.traitCollection.userInterfaceStyle == .dark {
                    title = NSAttributedString(string: tagTitle, attributes: [NSAttributedString.Key.foregroundColor: UIColor.mintGreen])
                } else {
                    title = NSAttributedString(string: tagTitle, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                }
            }
            return title
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedTagTitle = tagTitles[row]
        plantCollection = []
        if selectedTagTitle == "All" {
            plantCollection = getAllPlants()
        } else {
            let selectedTag = TagController.shared.getSelectedTag(givenTagTitle: selectedTagTitle)
            guard let tagPlants = selectedTag.plants?.array as? [Plant] else { return }
            for plant in tagPlants {
                plantCollection.append(plant)
            }
        }
        self.collectionView.reloadData()
        dismissFilter()
    }
    
    // MARK: - PopupDelegate Methods
    // TODO: - Want to just reload a single item in waterPlant() -- not the whole collectionView.
    
    func fertilizePlant() {
        print("Fertilize Plant")
        guard let plant = selectedPlant, let targetIndex = collectionView.indexPathsForSelectedItems else { return }
        if plant.needsFertilizedFireDate! > Date() {
            selectedIndex = targetIndex
            let todayAtFireHourMinute = DayHelper.shared.getSameTimeAsDateToday(targetDate: plant.needsFertilizedFireDate!)
            let nextWateringDay = DayHelper.shared.futureDateFromADate(givenDate: todayAtFireHourMinute,
                                                                       numberOfDays: Int(plant.daysToNextFertilize))
            let weeks = DayHelper.shared.translateDayIntToWeeks(givenAmountOfDays: Int(plant.daysToNextFertilize))
            var alarmMessage = String()
            switch plant.daysToNextFertilize {
            case 1:
                alarmMessage = "Your \(plant.name!) will have its fertilizer reminder moved to tomorrow: \(DayHelper.shared.formatMonthAndDay(givenDate: nextWateringDay)) at \(nextWateringDay.timeStringValue())"
            default:
                alarmMessage = "Your \(plant.name!) will have its fertilizer reminder moved \(weeks)from today: \(DayHelper.shared.formatMonthAndDay(givenDate: nextWateringDay)) at \(nextWateringDay.timeStringValue())"
            }
            let earlyWateringAlert = UIAlertController(title: "Early Fertilizing", message: alarmMessage, preferredStyle: .alert)
            earlyWateringAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            earlyWateringAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: fertilizePlantEarly(action:)))
            self.present(earlyWateringAlert, animated: true, completion: nil)
            self.collectionView.reloadItems(at: targetIndex)
        } else {
            PlantController.shared.fertilizePlant(plant: plant)
            self.collectionView.reloadItems(at: targetIndex)
            animateConfirmationImageView(notificationKey: Keys.fertilizerNotification)
        }
    }
    
    func showPlantFertilizerHistory() {
        performSegue(withIdentifier: "toShowFertilizerHistory", sender: self)
    }
    
    func editPlant() {
        performSegue(withIdentifier: "toEditPlant", sender: self)
    }
    
    func waterPlant() {
        guard let targetPlant = selectedPlant, let targetPlantName = selectedPlant?.name, let targetPlantFireDate = selectedPlant?.needsWateredFireDate, let targetIndex = collectionView.indexPathsForSelectedItems else { return }
        PlantController.shared.checkIfDry(plant: targetPlant)
        if targetPlant.isWatered == false {
            PlantController.shared.waterPlant(plant: targetPlant)
            if areAllPlantsWatered() {
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            }
            animateConfirmationImageView(notificationKey: Keys.waterNotification)
        } else {
            selectedIndex = targetIndex
            let todayAtFireHourMinute = DayHelper.shared.getSameTimeAsDateToday(targetDate: targetPlantFireDate)
            let nextWateringDay = DayHelper.shared.futureDateFromADate(givenDate: todayAtFireHourMinute, numberOfDays: Int(targetPlant.dayToNextWater))
            var alarmMessage = String()
            switch targetPlant.dayToNextWater {
            case 1:
                alarmMessage = "Your \(targetPlantName) will have its watering reminder moved to tomorrow: \(DayHelper.shared.formatMonthAndDay(givenDate: nextWateringDay)) at \(nextWateringDay.timeStringValue())"
            default:
                alarmMessage = "Your \(targetPlantName) will have its watering reminder moved \(targetPlant.dayToNextWater) days from today: \(DayHelper.shared.formatMonthAndDay(givenDate: nextWateringDay)) at \(nextWateringDay.timeStringValue())"
            }
            let earlyWateringAlert = UIAlertController(title: "Early Watering", message: alarmMessage, preferredStyle: .alert)
            earlyWateringAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            earlyWateringAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: waterPlantEarly(action:)))
            self.present(earlyWateringAlert, animated: true, completion: nil)
            self.collectionView.reloadItems(at: targetIndex)
        }
        self.collectionView.reloadItems(at: targetIndex)
    }
    
    // MARK: - Stored Properties
    let confirmationImageView = UIImageView(image: UIImage(named:"wateringConfirmationIcon"))
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    private let spacing: CGFloat = 16.0
    var tempInput: UITextField?
    var plantCollection: [Plant] = []
    var selectedPlant: Plant?
    var isDirty: Bool = false {
        didSet {
            cleanIfNeeded()
        }
    }
    var selectedIndex: [IndexPath]?
    
    // MARK: - Computed Properties
    
    var tagTitles: [String] {
        var titles = ["All"]
        let tagCollection = TagController.shared.tags
        for tag in tagCollection {
            guard let tagTitle = tag.title else { return titles }
            titles.append(tagTitle)
        }
        return titles
    }
    
    // MARK: - View LifeCycle
    #warning("Find a more effiecent way of refreshing the collection view")
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmationImageView.frame = CGRect(x: view.frame.midX - 75.0, y: view.frame.midY - 150.0, width: 150.0, height: 150.0)
        view.addSubview(confirmationImageView)
        confirmationImageView.isHidden = true
        // Notification Access Check:
        askForNotificationAccessIfNecessary()
    
        // CollectionView Setup:
        plantCollection = getAllPlants()
        self.collectionView.reloadData()
        
        // WillEnterForegroundNotification observer:
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        // PickerView Setup:
        self.tagFilterPickerView.delegate = self
        self.tagFilterPickerView.dataSource = self
        
        // CollectionViewLayout Setup:
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView?.collectionViewLayout = layout
        
        // GESTURE SETUPS:
        // TapToDismissFirstResponder Setup:
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        plantCollection = getAllPlants()
        self.collectionView.reloadData()
        self.navigationController?.setNeedsStatusBarAppearanceUpdate() 
    }
    
    // MARK: - Outlets
    
    @IBOutlet var tagFilterPickerView: UIPickerView!
    
    // MARK: - Actions
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        if tagFilterPickerView.superview != nil {
            return
        }
        // Using an 'invisible' textField here so I can use it as an input view for the tagFilter:
        let temporaryInput = UITextField(frame:CGRect.zero)
        temporaryInput.inputView = self.tagFilterPickerView
        self.view.addSubview(temporaryInput)
        temporaryInput.becomeFirstResponder()
        tempInput = temporaryInput
    }
    
    // MARK: - CollectionView DataSource Methods

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plantCollection.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PlantCollectionViewCell else {
            print("ERROR: The collectionViewCell is not an instance of PlantCollectionViewCell!")
            return UICollectionViewCell()
        }
        let selectedPlant = plantCollection[indexPath.row]
        setupCell(cell: cell, selectedPlant: selectedPlant)
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }

    // MARK: - CollectionView Delegate Methods

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let plant = plantCollection[indexPath.row]
        selectedPlant = plant
        displayPopupChildView(forSelectedPlant: plant)
    }
    
    // MARK: - Internal Methods
    
    private func animateConfirmationImageView(notificationKey: String) {
        if notificationKey == Keys.fertilizerNotification {
            confirmationImageView.image = UIImage(named:"fertilizingConfirmationIcon")
        } else {
            confirmationImageView.image = UIImage(named:"wateringConfirmationIcon")
        }
         UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {self.confirmationImageView.isHidden = false}, completion: {completion in UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {self.confirmationImageView.isHidden = true }, completion: nil)})
    }
    /// Returns an array that is populated with every Plant object.
    func getAllPlants() -> [Plant] {
        let intialResult: [Plant] = []
        return TagController.shared.tags.reduce(into: intialResult) { (plants, tag) in
            for plant in tag.plants!.array {
                if let plantObject = plant as? Plant {
                    plants.append(plantObject)
                }
            }
        }
    }
    
    /// Selector Method for the applicationWillEnterForeground: Sets the isDirty property to true.
    @objc private func enterForeground() {
        isDirty = true
    }
    
    /// Reloads the collection view if the current date is at or passed the fireDate for all plants in the Plant Collection Array.
    private func checkIfPlantsAreDryOrNeedFertilizing() {
        for plant in plantCollection {
            #warning("Need to check fertilizer dates as well")
            guard let wateringFireDate = plant.needsWateredFireDate else { return }
            if wateringFireDate <= Date()  {
                self.collectionView.reloadData()
                break
            }
            guard let fertilizingFireDate = plant.needsFertilizedFireDate else { return }
            if fertilizingFireDate <= Date() {
                self.collectionView.reloadData()
                break
            }
        }
    }
    
    /// If isDirty is true checkIfPlantsAreDry() is called and isDirty is reset to false.
    private func cleanIfNeeded() {
        if isDirty == true {
            //checkIfPlantsAreDryOrNeedFertilizing()
            self.collectionView.reloadData()
            isDirty = false
        }
    }

    /// Sets up the PlantCollectionViewCell elements with all the desired properties from the selected plant object.
    private func setupCell(cell: PlantCollectionViewCell, selectedPlant: Plant) {
        var daysToNextWater = String()
        if let fireDate = selectedPlant.needsWateredFireDate {
            if Date() <= fireDate || DayHelper.shared.twoDatesAreOnTheSameDay(dateOne: Date(), dateTwo: fireDate) {
                // The current Date is less than or on the same day as the notification:
                daysToNextWater = DayHelper.shared.amountOfDaysBetween(previousDate: Date(), futureDate: fireDate)
                PlantController.shared.checkIfDry(plant: selectedPlant)
                if PlantController.shared.isPlantDry(plant: selectedPlant) {
                    cell.waterNotificationStatusImageView.image = UIImage(named: Keys.wateringPailIcon)
                    cell.waterNotificationStatusImageView.tintColor = .dryRed
                } else {
                    cell.waterNotificationStatusImageView.image = UIImage(named: Keys.clockIcon)
                    cell.waterNotificationStatusImageView.tintColor = .defaultBlue
                    //cell.backgroundColor = UIColor.wateredBlue
                    //cell.plantNameLabel.backgroundColor = .mintGreen
                }
            } else {
                // The current Date has passed the notification date:
                daysToNextWater = DayHelper.shared.formatMonthAndDay(givenDate: fireDate)
                cell.waterNotificationStatusImageView.image = UIImage(named: Keys.wateringPailIcon)
                cell.waterNotificationStatusImageView.tintColor = .dryRed
               // cell.plantNameLabel.backgroundColor = .dryRed
            }
        }
        let selectedPlantTagColor = ColorHelper.colorFrom(colorNumber: selectedPlant.tag?.colorNumber ?? Double(Int.random(in: 1...6)))
        cell.plantNameLabel.text = selectedPlant.name
        cell.tagTitleLabel.text = selectedPlant.tag?.title
        cell.plantImageView.image = selectedPlant.photo
        cell.plantImageView.contentMode = .scaleAspectFill
        cell.tagColorView.backgroundColor = selectedPlantTagColor
        cell.waterNotificationStatusLabel.text = daysToNextWater
        cell.tagNameIconImageView.image = UIImage(named: Keys.tagIcon)
        // Check if isDarkMode is true - if so change the background details view to a darker gray and its text to white:
        if self.traitCollection.userInterfaceStyle == .dark {
            cell.detailsBackgroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7914972175)
            cell.tagTitleLabel.textColor = .white
            cell.waterNotificationStatusLabel.textColor = .white
        } else {
            cell.detailsBackgroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8112425085)
            cell.tagTitleLabel.textColor = .darkGrayBlue
            cell.waterNotificationStatusLabel.textColor = .darkGrayBlue
        }
        cell.tagNameIconImageView.tintColor = .defaultBlue
        ViewHelper.roundCornersOf(viewLayer: cell.detailsBackgroundView.layer, withRoundingCoefficient: 9.0)
        ViewHelper.roundCornersOf(viewLayer: cell.contentView.layer, withRoundingCoefficient: 6.0)
        ViewHelper.roundCornersOf(viewLayer: cell.layer, withRoundingCoefficient: 6.0)
        if selectedPlant.needsFertilizedFireDate != nil {
            PlantController.shared.checkIfFertilized(plant: selectedPlant)
            cell.fertilizerStatusImageView.isHidden = true
            cell.tagNameIconImageView.image = #imageLiteral(resourceName: "notTimeToWaterIcon")
            if !selectedPlant.isFertilized {
                cell.tagNameIconImageView.image = #imageLiteral(resourceName: "waterPlantIcon-1")
                cell.tagNameIconImageView.tintColor = .dryRed
                cell.tagTitleLabel.text =  selectedPlant.needsFertilizedFireDate?.dayMonthYearValue()
            } else {
                cell.tagNameIconImageView.tintColor = .fertilizerGreen
                cell.tagTitleLabel.text =  DayHelper.shared.amountOfDaysBetween(previousDate: Date(), futureDate: selectedPlant.needsFertilizedFireDate!)
            }
           } else {
               cell.fertilizerStatusImageView.isHidden = true
           }
    }
    
    /// Displays the watering and editing Popup for the selected plant object.
    private func displayPopupChildView(forSelectedPlant plant: Plant) {
        let plantPopupViewController = PlantPopupViewController(nibName: "PlantPopupViewController", bundle: nil)
        plantPopupViewController.delegate = self
        if plant.needsFertilizedFireDate != nil {
            plantPopupViewController.plantHasFertilizerReminder = true
        }
        self.addChild(plantPopupViewController)
        plantPopupViewController.view.frame = self.view.bounds
        self.view.addSubview(plantPopupViewController.view)
        plantPopupViewController.didMove(toParent: self)
        plantPopupViewController.plantNameLabel.text = plant.name
    }
    
    /// Removes the tagPickerView from it's superview, and resigns the first responder for the tempInput.
    private func dismissFilter() {
        tagFilterPickerView.removeFromSuperview()
        tempInput?.resignFirstResponder()
    }
    
    /// Handler for watering plants early: Grabs the selected plant and waters it (resets the notification fireDate) and reloads the collectionView.
    func waterPlantEarly(action: UIAlertAction) {
        guard let plant = selectedPlant else { return }
        PlantController.shared.waterPlant(plant: plant)
        guard let index = selectedIndex else { return }
        self.collectionView.reloadItems(at: index)
        animateConfirmationImageView(notificationKey: Keys.waterNotification)
    }
    
    func fertilizePlantEarly(action: UIAlertAction) {
        guard let plant = selectedPlant else { return }
        PlantController.shared.fertilizePlant(plant: plant)
        guard let index = selectedIndex else { return }
        self.collectionView.reloadItems(at: index)
        animateConfirmationImageView(notificationKey: Keys.fertilizerNotification)
    }
    
    /// Generates the notification access request alert if access has not been given.
    private func askForNotificationAccessIfNecessary() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings(completionHandler: checkNotificationStatus(settings:))
    }
    
    /// Asks for notificaiton access if the authorization was not authorized.
    func checkNotificationStatus(settings: UNNotificationSettings) {
        if settings.authorizationStatus != .authorized {
            let center = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            center.requestAuthorization(options: options) {
                (accepted, error) in
                if !accepted {
                    print("Notification access has been denied")
                }
            }
            #warning("check to make sure i can remove delegation here and still can get notification access")
            //UNUserNotificationCenter.current().delegate = self
        }
    }
    
    /// Returns true if every plant is watered, false if there is still at least one plant that is dry. Use this to remove all watering notifications - do this check when watering a plant.
    func areAllPlantsWatered() -> Bool {
        var truthValue = true
            for plant in plantCollection {
                let plantObject = plant
                if plantObject.isWatered == false {
                    truthValue = false
                    break
                }
            }
        return truthValue
    }
}

// MARK: - Delegate Flow Layout Extension

extension PlantCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 2
        let spacingBetweenCells: CGFloat = 16
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        if let collection = self.collectionView {
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
     // MARK: - Navigation
     
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toEditPlant" {
        guard let detailVC = segue.destination as? PlantDetailTableViewController, let plant = selectedPlant else { return }
        detailVC.plant = plant
        detailVC.plantTitle = (plant.name)!
        detailVC.tag = plant.tag
        detailVC.wateringReminderNext = plant.needsWateredFireDate
        detailVC.wateringDayInteger = Int(plant.dayToNextWater)
        detailVC.image = plant.photo
        if selectedPlant!.daysToNextFertilize != 0 {
            detailVC.fertilizerDayInteger = Int(selectedPlant!.daysToNextFertilize)
            detailVC.fertilizerReminderNext = selectedPlant?.needsFertilizedFireDate
        } else {
            detailVC.fertilizerDayInteger = nil
            detailVC.fertilizerReminderNext = nil
        }
        detailVC.navigationItem.title = selectedPlant?.name
    } else if segue.identifier == "toShowFertilizerHistory" {
        guard let historyVC = segue.destination as? FertilizerHistoryViewController, let plant = selectedPlant else { return }
        historyVC.plant = plant
        slideInTransitioningDelegate.direction = .bottom
        historyVC.transitioningDelegate = slideInTransitioningDelegate
        historyVC.modalPresentationStyle = .custom
        }
    }
}
