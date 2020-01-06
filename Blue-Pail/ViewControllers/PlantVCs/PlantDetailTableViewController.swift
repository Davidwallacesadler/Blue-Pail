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
            if plantTitle.isEmpty == false {
                titleCell.textField.text = plantTitle
            }
            cell = titleCell
        case 1:
            // Tag
            guard let tagPickerCell = tableView.dequeueReusableCell(withIdentifier: "pickerViewCell") as? PickerViewTableViewCell else { return UITableViewCell() }
            tagPickerCell.pickerView.delegate = self
            tagPickerCell.pickerView.dataSource = self
            if let selectedTagTitle = tag?.title {
                var index = 0
                for title in tagPickerTitles {
                    if title == selectedTagTitle {
                        break
                    }
                    index += 1
                }
                tagPickerCell.pickerView.selectRow(index, inComponent: 0, animated: false)
            }
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
                intervalCell.setupRemindersButton.setTitle("Setup Watering Reminders", for: .normal)
                intervalCell.nextLabel.text = "Next Watering:"
                intervalCell.nextLabel.tintColor = .deepBlue 
            default:
                intervalCell.cellKey = Keys.fertilizerNotification
                intervalCell.selectedInterval = fertilizerDayInteger
                intervalCell.nextReminderDate = fertilizerReminderNext
                intervalCell.setupRemindersButton.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
                intervalCell.setupRemindersButton.setTitle("Setup Fertilizing Reminders", for: .normal)
                intervalCell.nextLabel.text = "Next Fertilizing:"
                //intervalCell.nextLabel.tintColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
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
        return 1
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
                print("\(selectedTag.title)")
                
                
            }
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCustomCells()
        setupTableViewDelegation()
        // Selecting the first Tag by default, if there is one:
        if tagPickerTitles.isEmpty == false  && tag == nil {
            updateTag(selectedTag: TagController.shared.getSelectedTag(givenTagTitle: tagPickerTitles[0]))
        }
        // Gesture recognizer Setup:
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    override func viewDidAppear(_ animated: Bool) {
        // TODO: - Is there a better way of refreshing the data?
        //tagPickerView.reloadAllComponents()
    }
    
    // MARK: - Stored Properties
    var wateringDatePicker: UIDatePicker?
    var fertilizingDatePicker: UIDatePicker?
    var calendarKey: String?
    let sectionTitles = ["Title","Tag","Watering Reminder","Fertilizer Reminder", "Photo", "Delete"]
    
    // PLANT PROPERTIES
    var plant: Plant?
    var tag: Tag?
    var plantTitle = ""
    var wateringReminderNext: Date?
    var wateringDayInteger: Int?
    var fertilizerReminderNext: Date?
    var fertilizerDayInteger: Int?
    var image: UIImage?
    
    // MARK: - Computed Properties
    
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
    
    // MARK: - Actions
    
    // Navigation Controller Buttons:
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        #warning("first check if the plant name is unique - since i have no other unique identifiers for plant objects")
        updatePlantObject()
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
        if plantTitle.isEmpty {
            let noNameAlert = UIAlertController(title: "No Title Entered", message: "Please enter a title for your plant before saving.", preferredStyle: .alert)
            noNameAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(noNameAlert, animated: true)
            return
        }
        if tag == nil {
            let noTagAlert = UIAlertController(title: "No Tag Selected", message: "Please choose a tag for your plant before saving.", preferredStyle: .alert)
            noTagAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(noTagAlert, animated: true)
            return
        }
        guard let wateringDate = wateringReminderNext, let wateringDayInt = wateringDayInteger else {
            let noDateAlert = UIAlertController(title: "No Watering Reminder", message: "Please setup a reminder for watering your plant before saving.", preferredStyle: .alert)
            noDateAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(noDateAlert, animated: true)
            return
        }
        guard let selectedPlant = plant, let plantImage = image else {
            // CREATE
            PlantController.shared.createPlant(name: plantTitle,
                                               image: UIImage(named: Keys.noImage),
                                               needsWateredFireDate: wateringDate,
                                               tag: tag!,
                                               wateringDayInteger: wateringDayInt,
                                               fertilizingDayInteger: fertilizerDayInteger,
                                               needsFertilizedFireDate: fertilizerReminderNext)
            self.navigationController?.popViewController(animated: true)
            return
        }
        //UPDATE
        PlantController.shared.updatePlant(plant: selectedPlant,
                                           newName: plantTitle,
                                           newImage: plantImage,
                                           newWateringFireDate: wateringReminderNext,
                                           newTag: tag!,
                                           daysToNextWater: wateringDayInt,
                                           newFertilizerFireDate: fertilizerReminderNext,
                                           daysToNextFertilizing: fertilizerDayInteger)
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Updates the selected Tag reference, and related label and color view elements.
    private func updateTag(selectedTag: Tag) {
        tag = selectedTag
    }
    
    /// Removes the selected plant from its tag collecton, deletes it, and pops the viewController.
    private func deletePlant(action: UIAlertAction) {
        // Note: Remember to remove the plant from the tag collection before calling deletePlant(plant:) - Otherwise the Tag gets deleted along with it.
        guard let selectedPlant = plant, let plantTag = plant?.tag else { return }
        TagController.shared.removePlantFrom(targetTag: plantTag, desiredPlant: selectedPlant)
        PlantController.shared.deletePlant(plant: selectedPlant)
        self.navigationController?.popViewController(animated: true)
    }
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
        image = originalImage
        tableView.reloadSections(IndexSet([4]), with: .none)
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
