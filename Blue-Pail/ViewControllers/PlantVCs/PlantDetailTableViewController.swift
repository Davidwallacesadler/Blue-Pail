//
//  PlantDetailTableViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/7/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit



class PlantDetailTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, IntervalSelectionCellDelegate, ButtonCellDelegate, CalendarDateSelectionDelegate{
    
    // MARK: - Delegate Methods
    
    func updateDates(selectedKey key: String,
                     dateAndInterval: (Date, Int)) {
        switch key {
        case Keys.waterNotification:
            wateringReminderNext = dateAndInterval.0
            wateringDayInteger = dateAndInterval.1
            tableView.reloadSections(IndexSet([2]), with: .fade)
        case Keys.fertilizerNotification:
            fertilizerReminderNext = dateAndInterval.0
            fertilizerDayInteger = dateAndInterval.1
            tableView.reloadSections(IndexSet([3]), with: .fade)
        default:
            return
        }
    }
    
    // MARK: - Button Cell Delegation
    
    func buttonWasPressed(givenCellId: Int) {
        switch givenCellId {
        case 4:
            //Photo
            getImage()
        case 5:
            //Delete
            guard let _ = plant, let _ = plant?.tag, let plantName = plant?.name else {
                self.navigationController?.popViewController(animated: true)
                return
            }
            let deletePlantAlert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete your \(plantName) plant?", preferredStyle: .alert)
            deletePlantAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            deletePlantAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: deletePlant(action:)))
            self.present(deletePlantAlert, animated: true, completion: nil)
        default:
            return
        }
    }
    
    
    // MARK: - Interval Selection Delegation
    
    func segueToUpdateCalendar(givenCellKey: String) {
        calendarKey = givenCellKey
        self.performSegue(withIdentifier: "toShowReminderCalendar", sender: self)
    }
    
    
    #warning("TODO: Need to make center offset of dayslabel programmatic")
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return CGFloat(integerLiteral: 100)
        case 4:
            return CGFloat(integerLiteral: 200)
        default:
            return UITableView.automaticDimension
        }
    }
    
    // MARK: - TableView Datasource Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            // Title
            guard let titleCell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell") as? TextFieldTableViewCell else { return UITableViewCell()}
            titleCell.textField.delegate = self
            cell = titleCell
        case 1:
            // Tag
            guard let tagPickerCell = tableView.dequeueReusableCell(withIdentifier: "pickerViewCell") as? PickerViewTableViewCell else { return UITableViewCell() }
            tagPickerCell.pickerView.delegate = self
            tagPickerCell.pickerView.dataSource = self
            cell = tagPickerCell
        case 2,3:
            // Watering
            guard let intervalCell = tableView.dequeueReusableCell(withIdentifier: "intervalSelectionCell") as? DateIntervalSelectionTableViewCell  else { return UITableViewCell() }
            switch indexPath.section {
            case 2:
                intervalCell.cellKey = Keys.waterNotification
                intervalCell.selectedInterval = wateringDayInteger
                intervalCell.nextReminderDate = wateringReminderNext
                intervalCell.setupRemindersButton.backgroundColor = .deepBlue
                intervalCell.nextLabel.text = "Next Watering:"
                intervalCell.nextLabel.tintColor = .deepBlue 
            default:
                intervalCell.cellKey = Keys.fertilizerNotification
                intervalCell.selectedInterval = fertilizerDayInteger
                intervalCell.nextReminderDate = fertilizerReminderNext
                intervalCell.setupRemindersButton.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
                intervalCell.nextLabel.text = "Next Fertilizing:"
                intervalCell.nextLabel.tintColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            }
            intervalCell.reminderTimeDatePicker.addTarget(self, action: #selector(updateReminderTime(sender:)), for: .allEvents)
            intervalCell.datePickerTag = indexPath.section
            intervalCell.delegate = self
            if let nextReminder = intervalCell.nextReminderDate {
                intervalCell.reminderTimeDatePicker.setDate(nextReminder, animated: false)
            }
            cell = intervalCell
        case 4,5:
            // Photo
            guard let buttonCell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as? ButtonTableViewCell else { return UITableViewCell() }
            buttonCell.cellId = indexPath.section
            buttonCell.delegate = self
            switch indexPath.section {
            case 4:
                if let takenPhoto = image {
                    buttonCell.buttonImageView.image = takenPhoto
                } else {
                    buttonCell.buttonImageView?.image = #imageLiteral(resourceName: "photoButton-1")
                }
                buttonCell.button.backgroundColor = .clear
                buttonCell.button.setTitleColor(.clear, for: .normal)
                buttonCell.button.setTitle("", for: .normal)
                cell = buttonCell
            default:
//                buttonCell.buttonBackgroundColor = .red
//                deleteButtonCell.buttonTitleLabelColor = .white
                buttonCell.buttonImageView?.image = nil
                buttonCell.button.backgroundColor = .red
                buttonCell.button.setTitleColor(.white, for: .normal)
                buttonCell.button.setTitle("Delete", for: .normal)
                cell = buttonCell
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    @objc func updateReminderTime(sender: UIDatePicker) {
        switch sender.tag {
        case 2:
            // Water
            guard let wateringDate = wateringReminderNext else { return }
            wateringReminderNext = DayHelper.shared.getCorrectTimeOnDate(desiredHourMinuteDate: sender.date, date: wateringDate)
            tableView.reloadSections(IndexSet([2]), with: .none)
        case 3:
            // Fertilize
            guard let fertlizerDate = fertilizerReminderNext else { return }
            fertilizerReminderNext = DayHelper.shared.getCorrectTimeOnDate(desiredHourMinuteDate: sender.date, date: fertlizerDate)
            tableView.reloadSections(IndexSet([3]), with: .none)
        default:
            return
        }
        
    }
    // MARK: - TextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        plantTitle = textField.text ?? ""
    }
    
    // MARK: - PickerView Delegate Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == dayPickerView {
            return pickerData.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if tagPickerTitles.isEmpty {
            return 1
        } else {
            return tagPickerTitles.count
        }
    }
 
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if tagPickerTitles.isEmpty {
            return "Please Create A Tag"
        } else {
            return tagPickerTitles[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }

    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if tagPickerTitles.isEmpty == false {
        let tagTitle = tagPickerTitles[row]
        let tag = TagController.shared.getSelectedTag(givenTagTitle: tagTitle)
        let title = NSAttributedString(string: tagTitle, attributes: [NSAttributedString.Key.foregroundColor: ColorHelper.colorFrom(colorNumber: tag.colorNumber)])
        return title
        } else {
        return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("\(pickerView.tag)")
            if tagPickerTitles.isEmpty {
                return
            } else {
                let selectedTagTitle = tagPickerTitles[row]
                let selectedTag = TagController.shared.getSelectedTag(givenTagTitle: selectedTagTitle)
                updateTag(selectedTag: selectedTag)
            }
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCustomCells()
        setupTableViewDelegation()
        // Selecting the first Tag by default, if there is one:
        if tagPickerTitles.isEmpty == false {
            updateTag(selectedTag: TagController.shared.getSelectedTag(givenTagTitle: tagPickerTitles[0]))
        }
        
        // Rounding Corners:
        //ViewHelper.roundCornersOf(viewLayer: deletePlantButton.layer, withRoundingCoefficient: 20.0)
        // NavigationBar Setup:
        //NavigationBarHelper.setupNativationBar(viewController: self)
        
        // Gesture recognizer Setup:
//        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
//        tap.cancelsTouchesInView = false
//        self.view.addGestureRecognizer(tap)
//
//        // Segued Data Setup:
//        #warning("update this method")
//        updateViews()
//
//        // DayPicker Setup:
//        self.dayPickerView.delegate = self
//        self.dayPickerView.dataSource = self
//        pickerData = [
//            pickerDays
//        ]
//        self.dayPickerView.selectRow(0, inComponent: 0, animated: false)
//
//        // TagPicker Setup:
//        self.tagPickerView.delegate = self
//        self.tagPickerView.dataSource = self
//
//        // TextField Setup:
//        self.plantNameTextField.delegate = self
//
//        // UpdatePicker Setup:
//        updateDayPickerValue()
//        updateTagPickerValue()
//        updateTimeValues()
//
//        // didChangeThemeModeNotification observer:
//        NotificationCenter.default.addObserver(self, selector: #selector(didChangeThemeMode), name: .didChangeThemeMode, object: nil)
//
//        // Theme Setup:
//        self.isDarkMode = UserDefaults.standard.bool(forKey: Keys.themeMode)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        // TODO: - Is there a better way of refreshing the data?
        //tagPickerView.reloadAllComponents()
    }
    
    override func viewDidLayoutSubviews() {
       // swapColorsToDarkForTableViewIfNeeded()
//        if isDarkMode {
//            // PickerViews
//            tagPickerView.subviews[1].backgroundColor = .white
//            tagPickerView.subviews[2].backgroundColor = .white
//            dayPickerView.subviews[1].backgroundColor = .white
//            dayPickerView.subviews[2].backgroundColor = .white
//        }
    }
    
    // MARK: - Stored Properties
    #warning("setting this = to Darkmode.shared.isDarkmode is not working for me")
//    private var isDarkMode: Bool = UserDefaults.standard.bool(forKey: Keys.themeMode) {
//        didSet {
//            tableView.reloadData()
//            swapColorsIfNeeded()
//        }
//    }
    var wateringDatePicker: UIDatePicker?
    var fertilizingDatePicker: UIDatePicker?
    var calendarKey: String?
    var plantTitle = ""
    let sectionTitles = ["Title","Tag","Watering Reminder","Fertilizer Reminder", "Photo", "Delete"]
    var plant: Plant?
    var wateringReminderNext: Date?
    var wateringDayInteger: Int?
    var fertilizerReminderNext: Date?
    var fertilizerDayInteger: Int?
    var image: UIImage?
    var tag: Tag?
    var pickerDays = [
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
        21, 22, 24, 25, 26, 27, 28, 29, 30, 31
    ]
    var pickerData = [[Int]]()
    var selectedHour: Int?
    var selectedMinute: Int?
    
    // MARK: - Computed Properties
    
    // For Consistent rounding:
    var photoImageViewWidth: CGFloat {
        return self.photoImageView.frame.width
    }
    var deleteButtonViewHeight: CGFloat {
        guard let deletePlantButtonImageView = self.deletePlantButton.imageView else {
            return 50.0
        }
        return deletePlantButtonImageView.frame.height
    }
    var tagPickerTitles: [String] {
        get {
            let tags = TagController.shared.tags
            var tagTitles = [String]()
            for tag in tags {
                guard let tagTitle = tag.title else { return [] }
                tagTitles.append(tagTitle)
            }
            return tagTitles
        }
    }

    // MARK: - Outlets
    
    @IBOutlet var dayPickerView: UIPickerView!
    @IBOutlet weak var plantNameTextField: UITextField!
    @IBOutlet weak var notifcationDateLabel: UILabel!
    @IBOutlet weak var deletePlantButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var tagPickerView: UIPickerView!
    @IBOutlet weak var timeDatePicker: UIDatePicker!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dayPickerLabel: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
    
    // MARK: - Actions
    
    // Navigation Controller Buttons:
    @IBAction func timeDatePickerChanged(_ sender: Any) {
        let selectedDate = timeDatePicker.date
        let calendar = Calendar.current
        let desiredComponents = calendar.dateComponents([.hour, .minute], from: selectedDate)
        guard let hour = desiredComponents.hour, let minute = desiredComponents.minute else {
            return
        }
        selectedHour = hour
        selectedMinute = minute
        var day = 0
        if wateringDayInteger != nil {
            day = wateringDayInteger ?? 0
        }
        let desiredNotificationTimeToday = DayHelper.shared.getCorrectTimeToday(desiredHourMinute: (hour, minute))
        let notificationDate = DayHelper.shared.futureDateFromADate(givenDate: desiredNotificationTimeToday, numberOfDays: day)
        wateringReminderNext = notificationDate
      //  self.notifcationDateLabel.text = notificationDate.stringValue()
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        #warning("first check if the plant name is unique - since i have no other unique identifiers for plant objects")
        updatePlantObject()
    }
    
    // TableView Buttons:
    @IBAction func imageButtonPressed(_ sender: Any) {
        #warning("fix the breaking constriants that are causing lag here")
        
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
       
    }
    
    // MARK: - Internal Methods
    
    private func setupTableViewDelegation() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func registerCustomCells() {
        tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "textFieldCell")
        tableView.register(UINib(nibName: "PickerViewTableViewCell", bundle: nil), forCellReuseIdentifier: "pickerViewCell")
        tableView.register(UINib(nibName: "DateIntervalSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "intervalSelectionCell")
        tableView.register(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "buttonCell")
    }
    
     /// Updates the plant object if there was one passed in, otherwise creates a new plant object with the components from the view.
    private func updatePlantObject() {
        guard let plantName = plantNameTextField.text.nilIfEmpty else {
            let noNameAlert = UIAlertController(title: "No Title Entered", message: "Please enter a title for your plant.", preferredStyle: .alert)
            noNameAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(noNameAlert, animated: true)
            return
        }
        guard let selectedTag = tag else {
            let noTagAlert = UIAlertController(title: "No Tag Selected", message: "Please choose a tag for your plant.", preferredStyle: .alert)
            noTagAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(noTagAlert, animated: true)
            return
        }
        guard let wateringDate = wateringReminderNext, let dayInt = wateringDayInteger else {
            let noDateAlert = UIAlertController(title: "No Day or Time Selected", message: "Please select a notifcation day & time for your plant.", preferredStyle: .alert)
            noDateAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(noDateAlert, animated: true)
            return
        }
        guard let selectedPlant = plant, let plantImage = image else {
            // CREATE
            //PlantController.shared.createPlant(name: plantName, image: image ?? UIImage(named: Keys.noImage), needsWaterFireDate: wateringDate, tag: selectedTag, dayInteger: dayInt)
            self.navigationController?.popViewController(animated: true)
            return
        }
        //UPDATE
        //PlantController.shared.updatePlant(plant: selectedPlant, newName: plantName, newImage: plantImage, newFireDate: wateringDate, newTag: selectedTag, dayInteger: dayInt)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    /// Updates the components of the view with the properties of the passed in plant.
    private func updateViews() {
        guard let selectedPlant = plant, let plantTag = plant?.tag, let plantImage = plant?.photo, let fireDate = plant?.needsWateredFireDate, let plantDay = plant?.dayToNextWater else { return }
        plantNameTextField.text = selectedPlant.name
        updateTag(selectedTag: plantTag)
        image = plantImage
        wateringDayInteger = Int(plantDay)
        checkDayValue()
        wateringReminderNext = fireDate
        if Date() <= fireDate {
            notifcationDateLabel.text = "\(fireDate.stringValue())"
            notifcationDateLabel.textColor = UIColor.darkBlue
        } else {
            notifcationDateLabel.text = "\(fireDate.stringValue())(Past Due)"
            notifcationDateLabel.textColor = UIColor.redOrange
        }
        photoImageView.image = plantImage
        photoImageView.contentMode = .scaleAspectFill
        // 3.0 7 plus
        //
            ViewHelper.roundCornersOf(viewLayer: photoImageView.layer, withRoundingCoefficient: Double(photoImageViewWidth * 0.2))
        updateDatePickerValue()
    }
    
    /// Updates the selected Tag reference, and related label and color view elements.
    private func updateTag(selectedTag: Tag) {
        tag = selectedTag
    }
    
    /// Updates the DayPickerView selected row if there is a dayInteger passed in.
    private func updateDayPickerValue() {
        guard let day = wateringDayInteger else {
            wateringDayInteger = 1
            return
        }
        var index = 0
        for integer in pickerDays {
            if integer == day {
                break
            }
            index += 1
        }
        dayPickerView.selectRow(index, inComponent: 0, animated: false)
    }
    
    /// Updates the tagPickerView selected row if there is a tag passed in.
    private func updateTagPickerValue() {
        guard let selectedTagTitle = tag?.title else { return }
        var index = 0
        for title in tagPickerTitles {
            if title == selectedTagTitle {
                break
            }
            index += 1
        }
        tagPickerView.selectRow(index, inComponent: 0, animated: false)
    }
    
    /// Sets the selectedHour and selectedMinute to the current time if there is no needsWateringDateValue passed in.
    private func updateTimeValues() {
        guard let wateringDate = wateringReminderNext else {
            wateringReminderNext = Date()
            selectedHour = Date().hourOfCurrentDate()
            selectedMinute = Date().minuteOfCurrentDate()
            return
        }
        selectedHour = wateringDate.hourOfCurrentDate()
        selectedMinute = wateringDate.minuteOfCurrentDate()
    }
    
     /// Updates the timeDatePickerView selected row if there is a notification date passed in.
    private func updateDatePickerValue() {
        guard let fireDate = wateringReminderNext else { return }
        timeDatePicker.setDate(fireDate, animated: false)
    }
    
    /// Updates the size of the imageView to corrospond with the size of the view
//    private func tableSetup() {
//        self.tableView.rowHeight = UITableView.automaticDimension
//        self.tableView.estimatedRowHeight = 44.0
//    }
    
    /// Removes the selected plant from its tag collecton, deletes it, and pops the viewController.
    private func deletePlant(action: UIAlertAction) {
        // Note: Remember to remove the plant from the tag collection before calling deletePlant(plant:) - Otherwise the Tag gets deleted along with it.
        guard let selectedPlant = plant, let plantTag = plant?.tag else { return }
        TagController.shared.removePlantFrom(targetTag: plantTag, desiredPlant: selectedPlant)
        PlantController.shared.deletePlant(plant: selectedPlant)
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Checks if the DayInteger is greater than one - if so it will update the DayPickerLabel to "Days".
    private func checkDayValue() {
        if wateringDayInteger == 1 {
            dayPickerLabel.text = "Day"
        } else {
           dayPickerLabel.text = "Days"
        }
    }
    
//    @objc private func didChangeThemeMode() {
//        isDarkMode = UserDefaults.standard.bool(forKey: Keys.themeMode)
//    }
    
    #warning("see if UIcolor.darkGray and UIColor.tableViewSectionDarkGray are the same - if so delete the latter")
    
//    private func swapColorsToDarkForTableViewIfNeeded() {
//        if isDarkMode {
//            // TableView Cells:
//            for view in self.tableView.subviews {
//                if view is UITableViewHeaderFooterView == false {
//                    view.backgroundColor = .black
//                }
//            }
//            // TableView Sections:
//            self.tableView.backgroundColor = .black
//            for section in 0..<tableView.numberOfSections {
//                guard let tableViewSection = tableView.headerView(forSection: section) else {
//                    return
//                }
//                let backgroundView = UIView(frame:tableViewSection.bounds)
//                backgroundView.backgroundColor = .darkModeGray
//                tableViewSection.backgroundView = backgroundView
//                tableViewSection.textLabel?.textColor = .white
//            }
//        } else {
//            // TableView Cells:
//            for view in self.tableView.subviews {
//                if view is UITableViewHeaderFooterView == false {
//                    view.backgroundColor = .white
//                }
//            }
//            // TableView Sections:
//            self.tableView.backgroundColor = .white
//            for section in 0..<tableView.numberOfSections {
//                guard let tableViewSection = tableView.headerView(forSection: section) else {
//                    return
//                }
//                let backgroundView = UIView(frame:tableViewSection.bounds)
//                backgroundView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
//                tableViewSection.backgroundView = backgroundView
//                tableViewSection.textLabel?.textColor = .darkGrayBlue
//            }
//        }
//    }
    
    
    /// Swaps the colors of all the elements in the view to their dark mode versions.
//    func swapColorsToDark() {
//        // Self:
//        self.view.backgroundColor = .black
//        // Navigation Controller:
//        NavigationBarHelper.setupDarkModeNavigationBar(viewController: self)
//        self.navigationItem.leftBarButtonItem?.tintColor = .white
//        self.navigationItem.rightBarButtonItem?.tintColor = .white
//        self.navigationController?.navigationBar.barStyle = .black
//        //Outlets:
//        #warning("TODO: Autocomplete block is black - see how to fix this")
//        let placeholderAttributes = [ NSAttributedString.Key.foregroundColor : UIColor.white]
//        let placeholder = NSAttributedString(string: "Please enter a title...", attributes: placeholderAttributes)
//        self.plantNameTextField.attributedPlaceholder = placeholder
//        self.plantNameTextField.backgroundColor = .gray
//        self.plantNameTextField.textColor = .white
//        self.plantNameTextField.keyboardAppearance = .dark
//        self.notifcationDateLabel.textColor = .skyBlue
//        self.dayPickerLabel.textColor = .white
//        self.nextLabel.textColor = .white
//        self.timeDatePicker.setValue(UIColor.white, forKey: "textColor")
//        if plant == nil {
//            self.photoImageView.tintColor = .white
//        }
//        //        pickerView.subviews[1].backgroundColor = UIColor.whiteColor()
//        //        pickerView.subviews[2].backgroundColor = UIColor.whiteColor()
//
//
//    }
//
//    /// Swaps the colors of all the elements in the view to their defualt (light) versions.
//    func swapColorsToLight() {
//        //  NavigationBar:
//        NavigationBarHelper.setupNativationBar(viewController: self)
//        self.navigationItem.leftBarButtonItem?.tintColor = .darkGrayBlue
//        self.navigationItem.rightBarButtonItem?.tintColor = .darkGrayBlue
//        self.navigationController?.navigationBar.barStyle = .default
//        // TableView:
//        self.tableView.backgroundColor = .white
//
//    }
//
//    /// Calls swapColorsToLight or swapColorsToDark depending on the set themeMode.
//    func swapColorsIfNeeded() {
//        if UserDefaults.standard.bool(forKey: Keys.themeMode) {
//            swapColorsToDark()
//        } else {
//            swapColorsToLight()
//        }
//    }
}

// MARK: - UIImagePickerControllerDelegate Extension
// TODO: - Make it so the image fits into the button properly and isn't resizing it:

extension PlantDetailTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// Brings up an action sheet for image selection, and displays the selected image on the imageButton.
    func getImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                print("Camera not available")
                let alertController = UIAlertController(title: "Camera not available", message: "You have not given permission to use the camera or there is not an available camera to use.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(_) in
        }))
        if let popoverController = actionSheet.popoverPresentationController {
            let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
                actionSheet.dismiss(animated: true, completion: nil)
            })
            actionSheet.addAction(cancelButton)
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
//        photoImageView.image = originalImage
//        photoImageView.contentMode = .scaleAspectFill
//        if photoImageViewWidth < 193.0 {
//            ViewHelper.roundCornersOf(viewLayer: photoImageView.layer, withRoundingCoefficient: Double(photoImageViewWidth / 4.0))
//        } else {
//            ViewHelper.roundCornersOf(viewLayer: photoImageView.layer, withRoundingCoefficient: Double(photoImageViewWidth / 3.0))
//        }
        image = originalImage
        tableView.reloadSections(IndexSet([4]), with: .fade)
        picker.dismiss(animated: true, completion: nil)
    }
}

extension PlantDetailTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowReminderCalendar" {
            guard let calendarVC = segue.destination as? CalendarDateSelectionViewController, let key = calendarKey else { return }
            calendarVC.delegate = self
            calendarVC.reminderKey = key
        }
    }
}
