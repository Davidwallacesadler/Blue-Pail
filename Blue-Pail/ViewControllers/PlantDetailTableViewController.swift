//
//  PlantDetailTableViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/7/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class PlantDetailTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // TODO: 
    
    // MARK: - Picker Protocol Stubs
    
    // Columns in picker:
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    // Rows in picker:
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    // Titles of Rows:
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return String(pickerData[component][row])
    }
    
    // TODO: - Get the picker to work with multiple components --
    // Want to check if each one has changed individually:
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let day = pickerDays[pickerView.selectedRow(inComponent: 0)]
        let hour = pickerHours[pickerView.selectedRow(inComponent: 1)]
        let minute = pickerMinutes[pickerView.selectedRow(inComponent: 2)]
        dayInteger = day
        let desiredNotificationTimeToday = DayHelper.getCorrectTimeToday(desiredHourMinute: (hour, minute))
        let notificationDate = DayHelper.futureDateFromADate(givenDate: desiredNotificationTimeToday, numberOfDays: day)
        print("\(notificationDate)")
        needsWateringDateValue = notificationDate
        self.notifcationDateLabel.text = notificationDate.stringValue()
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gesture recognizer Setup:
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        updateViews()
        
        // Picker Setup:
        self.dayPickerView.delegate = self
        self.dayPickerView.dataSource = self
        pickerDays = [
            1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
            11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
            21, 22, 24, 25, 26, 27, 28, 29, 30, 31
        ]
        pickerHours = [
            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
            11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
            21, 22, 23
        ]
        pickerMinutes = [
            0, 15, 30, 45
        ]
        pickerData = [
            pickerDays,
            pickerHours,
            pickerMinutes
        ]
        
        let dayLabel = UILabel()
        dayLabel.text = "day"
        let hourLabel = UILabel()
        hourLabel.text = "hour"
        let minuteLabel = UILabel()
        minuteLabel.text = "min"
        pickerLabels = [
            0 : dayLabel,
            1 : hourLabel,
            2 : minuteLabel
        ]
        
        
        // View Setup:
        self.notificationIconImageView.image = UIImage(named: "waterPlantIcon")
        self.tagIconImageView.image = UIImage(named: "tagNameIcon")
        self.dayPickerView.setPickerLabels(labels: pickerLabels, containedView: dayPickerView.superview ?? self.view)
        if plant == nil {
            deletePlantButton.backgroundColor = UIColor.gray
        }
        
    }
    
    // MARK: - Properties
    
    var plant: Plant?
    var needsWateringDateValue: Date?
    var dayInteger: Int?
    var image: UIImage?
    var tag: Tag?
    var pickerDays = [Int]()
    var pickerHours = [Int]()
    var pickerMinutes = [Int]()
    var pickerData = [[Int]]()
    var pickerLabels = [Int:UILabel]()
    
    
    // MARK: - Outlets
    
    @IBOutlet var dayPickerView: UIPickerView!
    @IBOutlet weak var plantNameTextField: UITextField!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var crimsonButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var selectedTagColorView: UIView!
    @IBOutlet weak var selectedTagLabel: UILabel!
    @IBOutlet weak var notifcationDateLabel: UILabel!
    @IBOutlet weak var notificationIconImageView: UIImageView!
    @IBOutlet weak var tagIconImageView: UIImageView!
    @IBOutlet weak var deletePlantButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    
    
    
    // MARK: - Actions
    // TODO: - Make the text field for the tag title to be a picker with the names
    
    // Navigation Controller Buttons
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        updatePlant()
    }
    
    //Photo
    @IBAction func imageButtonPressed(_ sender: Any) {
        getImage()
    }
    
    
    
    // Color Buttons
    @IBAction func orangeButtonPressed(_ sender: Any) {
        let selectedTag = TagController.shared.tags[0]
        tag = selectedTag
        updateTagSelection(tag: selectedTag)
        orangeButton.showsTouchWhenHighlighted = true
    }
    
    @IBAction func greenButtonPressed(_ sender: Any) {
        let selectedTag = TagController.shared.tags[1]
        tag = selectedTag
        updateTagSelection(tag: selectedTag)
        greenButton.showsTouchWhenHighlighted = true
    }
    
    @IBAction func blueButtonPressed(_ sender: Any) {
        let selectedTag = TagController.shared.tags[2]
        tag = selectedTag
        updateTagSelection(tag: selectedTag)
        blueButton.showsTouchWhenHighlighted = true
    }
    
    @IBAction func crimsonButtonPressed(_ sender: Any) {
        let selectedTag = TagController.shared.tags[3]
        tag = selectedTag
        updateTagSelection(tag: selectedTag)
        crimsonButton.showsTouchWhenHighlighted = true
    }
    
    @IBAction func purpleButtonPressed(_ sender: Any) {
        let selectedTag = TagController.shared.tags[4]
        tag = selectedTag
        updateTagSelection(tag: selectedTag)
        purpleButton.showsTouchWhenHighlighted = true
    }
    
    @IBAction func redButtonPressed(_ sender: Any) {
        let selectedTag = TagController.shared.tags[5]
        tag = selectedTag
        updateTagSelection(tag: selectedTag)
        redButton.showsTouchWhenHighlighted = true
    }
    
    // CRUD
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        guard let selectedPlant = plant else { return }
        PlantController.shared.deletePlant(plant: selectedPlant)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Internal Methods
    
    // TODO: - Work on getting image set up to see if PlantController.update is being called properly
    
    /// Updates the plant object if there was one passed in, otherwise creates a new plant object with the components from the view.
    private func updatePlant() {
        guard let selectedPlant = plant, let plantName = plantNameTextField.text, let needsWateringDate = needsWateringDateValue, let selectedTag = tag, let plantImage = image, let selectedDay = dayInteger else {
            PlantController.shared.createPlant(name: plantNameTextField.text ?? "Plant", image: image ?? UIImage(named: "defualt"), needsWaterFireDate: needsWateringDateValue ?? DayHelper.futrueDateFrom(givenNumberOfDays: 1), tag: tag ?? TagController.shared.tags[0], dayInteger: dayInteger ?? 1)
            self.navigationController?.popViewController(animated: true)
            return
        }
        PlantController.shared.updatePlant(plant: selectedPlant, newName: plantName, newImage: plantImage, newFireDate: needsWateringDate, newTag: selectedTag, dayInteger: selectedDay)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    /// Updates the components of the view with the properties of the passed in plant.
    private func updateViews() {
        guard let selectedPlant = plant, let plantTag = plant?.tag, let plantImage = plant?.photo else { return }
        plantNameTextField.text = selectedPlant.name
        updateTagSelection(tag: plantTag)
        notifcationDateLabel.text = selectedPlant.needsWateredFireDate?.stringValue()
        imageButton.imageView?.image = plantImage
        imageButton.imageView?.contentMode = .scaleAspectFill
    }
    
    /// Updates the selected tag label and color view.
    private func updateTagSelection(tag: Tag) {
        selectedTagLabel.text = tag.title
        selectedTagColorView.backgroundColor = ColorHelper.colorFrom(colorNumber: tag.colorNumber)
    }
    
}

extension PlantDetailTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func getImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo", message: "Choose Source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                print("Camera not available")
                let alertController = UIAlertController(title: "Camera not available", message: "You have not given permission to use the camera or there is not available camera to use.", preferredStyle: .alert)
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
        imageButton.imageView?.contentMode = .scaleAspectFill
        imageButton.setImage(originalImage, for: .normal)
        image = originalImage
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}
