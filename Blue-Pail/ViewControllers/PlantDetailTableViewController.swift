//
//  PlantDetailTableViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/7/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class PlantDetailTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // MARK: - TextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        if pickerView == dayPickerView {
            return pickerData[component].count
        } else {
            if tagPickerTitles.isEmpty {
                return 1
            } else {
                return tagPickerTitles.count
            }
        }

    }
 
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == dayPickerView {
            return String(pickerData[component][row])
        } else {
            if tagPickerTitles.isEmpty {
                return "Please Create A Tag"
            } else {
                return tagPickerTitles[row]
            }
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == dayPickerView {
            let day = pickerDays[pickerView.selectedRow(inComponent: 0)]
            var hour = 0
            var minute = 0
            if selectedHour != nil {
                hour = selectedHour ?? 0
            }
            if selectedMinute != nil {
                minute = selectedMinute ?? 0
            }
            dayInteger = day
            let desiredNotificationTimeToday = DayHelper.getCorrectTimeToday(desiredHourMinute: (hour, minute))
            let notificationDate = DayHelper.futureDateFromADate(givenDate: desiredNotificationTimeToday, numberOfDays: day)
            print("\(notificationDate)")
            needsWateringDateValue = notificationDate
            self.notifcationDateLabel.text = notificationDate.stringValue()
        } else {
            if tagPickerTitles.isEmpty {
                return
            } else {
                let selectedTagTitle = tagPickerTitles[row]
                let selectedTag = TagController.shared.getSelectedTag(givenTagTitle: selectedTagTitle)
                updateTag(selectedTag: selectedTag)
            }
        }
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Check if There is only one group:
        if tagPickerTitles.count == 1 {
            updateTag(selectedTag: TagController.shared.getSelectedTag(givenTagTitle: tagPickerTitles[0]))
        }
        
        // NavigationBar Setup:
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.pailBlue,
             NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 18)!]
        
        // Gesture recognizer Setup:
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        updateViews()
        
        // Picker Setup:
        self.dayPickerView.delegate = self
        self.dayPickerView.dataSource = self
        
        // Day Picker Setup:
        self.tagPickerView.delegate = self
        self.tagPickerView.dataSource = self
        pickerData = [
            pickerDays
        ]
        updateDayPickerValue()
        // Day Picker Label Setup:
        let dayLabel = UILabel()
        dayLabel.text = "day(s)"
        pickerLabels = [
            0 : dayLabel
        ]
        
        // TextField Setup:
        self.plantNameTextField.delegate = self
        
        // View Setup:
        self.dayPickerView.setPickerLabels(labels: pickerLabels, containedView: dayPickerView.superview ?? self.view)
        if plant == nil {
            deletePlantButton.backgroundColor = UIColor.gray
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        // TODO: - Is there a better way of refreshing the data?
        tagPickerView.reloadAllComponents()
    }
    
    // MARK: - Properties
    
    // Plant Properties:
    var plant: Plant?
    var needsWateringDateValue: Date?
    var dayInteger: Int?
    var image: UIImage?
    var tag: Tag?
    
    // Picker Properties:
    var pickerDays = [
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
        21, 22, 24, 25, 26, 27, 28, 29, 30, 31
    ]
    var pickerData = [[Int]]()
    var pickerLabels = [Int:UILabel]()
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
    var selectedHour: Int?
    var selectedMinute: Int?
    
    // MARK: - Outlets
    
    @IBOutlet var dayPickerView: UIPickerView!
    @IBOutlet weak var plantNameTextField: UITextField!
    @IBOutlet weak var selectedTagColorView: UIView!
    @IBOutlet weak var selectedTagLabel: UILabel!
    @IBOutlet weak var notifcationDateLabel: UILabel!
    @IBOutlet weak var deletePlantButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var tagPickerView: UIPickerView!
    @IBOutlet weak var timeDatePicker: UIDatePicker!
    @IBOutlet weak var photoImageView: UIImageView!
    
    // MARK: - Actions
    // TODO: - Make the text field for the tag title to be a picker with the names
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
        if dayInteger != nil {
            day = dayInteger ?? 0
        }
        let desiredNotificationTimeToday = DayHelper.getCorrectTimeToday(desiredHourMinute: (hour, minute))
        let notificationDate = DayHelper.futureDateFromADate(givenDate: desiredNotificationTimeToday, numberOfDays: day)
        needsWateringDateValue = notificationDate
        self.notifcationDateLabel.text = notificationDate.stringValue()
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        updatePlantObject()
    }
    
    @IBAction func imageButtonPressed(_ sender: Any) {
        getImage()
    }
    
    /// Note: - Remember to remove the plant from the tag collection before calling deletePlant(plant:) - Otherwise the Tag gets deleted along with it.
    @IBAction func deleteButtonPressed(_ sender: Any) {
        guard let selectedPlant = plant, let plantTag = plant?.tag else { return }
        TagController.shared.removePlantFrom(targetTag: plantTag, desiredPlant: selectedPlant)
        PlantController.shared.deletePlant(plant: selectedPlant)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Internal Methods
    
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
        guard let wateringDate = needsWateringDateValue, let dayInt = dayInteger else {
            let noDateAlert = UIAlertController(title: "No Day or Time Selected", message: "Please select a notifcation day & time for your plant.", preferredStyle: .alert)
            noDateAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(noDateAlert, animated: true)
            return
        }
        guard let selectedPlant = plant, let plantImage = image else {
            // CREATE
            PlantController.shared.createPlant(name: plantName, image: image ?? UIImage(named: "Default"), needsWaterFireDate: wateringDate, tag: selectedTag, dayInteger: dayInt)
            self.navigationController?.popViewController(animated: true)
            return
        }
        //UPDATE
        PlantController.shared.updatePlant(plant: selectedPlant, newName: plantName, newImage: plantImage, newFireDate: wateringDate, newTag: selectedTag, dayInteger: dayInt)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // TODO: - Update the Pickerview to the last selected values --- can get from fireDate and DaysTillNext
    /// Updates the components of the view with the properties of the passed in plant.
    private func updateViews() {
        guard let selectedPlant = plant, let plantTag = plant?.tag, let plantImage = plant?.photo, let fireDate = plant?.needsWateredFireDate, let plantDay = plant?.dayToNextWater else { return }
        plantNameTextField.text = selectedPlant.name
        updateTag(selectedTag: plantTag)
        image = plantImage
        dayInteger = Int(plantDay)
        needsWateringDateValue = fireDate
        notifcationDateLabel.text = selectedPlant.needsWateredFireDate?.stringValue()
        photoImageView.image = plantImage
        photoImageView.contentMode = .scaleAspectFill
        // UPDATE THE DAY PICKER TO DISPLAY THE DAY
        //dayPickerView.selec
        //updateDayPickerValue()
        // UPDATE THE TIME PICKER TO DISPLAY THE TIME
        updateDatePickerValue()
    }
    
    /// Updates the selected Tag reference, and related label and color view elements:
    private func updateTag(selectedTag: Tag) {
        tag = selectedTag
        selectedTagLabel.text = selectedTag.title
        selectedTagColorView.backgroundColor = ColorHelper.colorFrom(colorNumber: selectedTag.colorNumber)
    }
    
    /// Updates the DayPickerView selected row if there is a dayInteger passed in:
    private func updateDayPickerValue() {
        guard let day = dayInteger else { return }
        var index = 0
        for integer in pickerDays {
            if integer == day {
                break
            }
            index += 1
        }
        dayPickerView.selectRow(index, inComponent: 0, animated: false)
    }
    
     /// Updates the timeDatePickerView selected row if there is a notification date passed in:
    private func updateDatePickerValue() {
        guard let fireDate = needsWateringDateValue else { return }
        timeDatePicker.setDate(fireDate, animated: false)
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
        photoImageView.image = originalImage
        photoImageView.contentMode = .scaleAspectFill
//        imageButton.setImage(originalImage, for: .normal)
//        imageButton.imageView?.contentMode = .scaleAspectFit
        image = originalImage
        picker.dismiss(animated: true, completion: nil)
    }
}
