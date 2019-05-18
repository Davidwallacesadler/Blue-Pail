//
//  PlantDetailTableViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/7/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class PlantDetailTableViewController: UITableViewController {
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Properties
    
    var plant: Plant? {
        didSet {
            updateViews()
        }
    }
    var needsWateringDateValue: Date?
    /*
     var needsWateringDateValue: Date? {
        didSet {
            self =
        }
     }
     */
    
    
    var dayInteger: Int?
    var image: UIImage?
    var tag: Tag?
    let pickerIntegers: [Int] = [
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
        21, 22, 24, 25, 26, 27, 28, 29, 30, 31
    ]
    
    // MARK: - Outlets
    
    @IBOutlet weak var plantNameTextField: UITextField!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var crimsonButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
     // MARK: - Actions
    // TODO: - Make the text field for the tag title to be a picker with the names
    // PICKER IS THE BEST -- WORKS BEST FOR WHEN EDITING THE PLANT - COULD POPULATE THE TEXT WITH THE SELECTED TAG NAME
    
    // Navigation Controller Buttons
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        updatePlant()
    }
    
    // Date Picker
    @IBAction func datePickerDateChanged(_ sender: UIDatePicker) {
        needsWateringDateValue = sender.date
    }
    
    // Color Buttons
    @IBAction func orangeButtonPressed(_ sender: Any) {
        tag = TagController.shared.tags[0]
        orangeButton.showsTouchWhenHighlighted = true
    }
    
    @IBAction func greenButtonPressed(_ sender: Any) {
        tag = TagController.shared.tags[1]
        greenButton.showsTouchWhenHighlighted = true
    }
    
    @IBAction func blueButtonPressed(_ sender: Any) {
        tag = TagController.shared.tags[2]
        blueButton.showsTouchWhenHighlighted = true
    }
    
    @IBAction func crimsonButtonPressed(_ sender: Any) {
        tag = TagController.shared.tags[3]
        crimsonButton.showsTouchWhenHighlighted = true
    }
    
    @IBAction func purpleButtonPressed(_ sender: Any) {
        tag = TagController.shared.tags[4]
        purpleButton.showsTouchWhenHighlighted = true
    }
    
    @IBAction func redButtonPressed(_ sender: Any) {
        tag = TagController.shared.tags[5]
        redButton.showsTouchWhenHighlighted = true
    }
    
    // MARK: - Methods
    
    func updatePlant() {
        guard let selectedPlant = plant, let plantName = plantNameTextField.text, let needsWateringDate = needsWateringDateValue, let selectedTag = tag, let plantImage = image else {
            PlantController.shared.createPlant(name: plantNameTextField.text ?? "Plant", image: UIImage(named: "defualt"), needsWaterFireDate: needsWateringDateValue ?? Date(), tag: tag ?? TagController.shared.tags[0])
            self.navigationController?.popViewController(animated: true)
            return
        }
        PlantController.shared.updatePlant(plant: selectedPlant, newName: plantName, newImage: plantImage, newFireDate: needsWateringDate, newTag: selectedTag)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func updateViews() {
        guard let selectedPlant = plant else { return }
        plantNameTextField.text = selectedPlant.name
       // tagTitleTextField.text = selectedPlant.tag?.title
        
    }

}
