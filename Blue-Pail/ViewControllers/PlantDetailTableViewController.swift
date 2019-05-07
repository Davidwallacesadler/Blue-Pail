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
    var color: Double?
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var plantNameTextField: UITextField!
    @IBOutlet weak var tagTitleTextField: UITextField!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var crimsonButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
     // MARK: - Actions
    
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
        color = 1.0
        orangeButton.showsTouchWhenHighlighted = true
    }
    
    @IBAction func greenButtonPressed(_ sender: Any) {
        color = 2.0
        greenButton.showsTouchWhenHighlighted = true
    }
    
    @IBAction func blueButtonPressed(_ sender: Any) {
        color = 3.0
        blueButton.showsTouchWhenHighlighted = true
    }
    
    @IBAction func crimsonButtonPressed(_ sender: Any) {
        color = 4.0
        crimsonButton.showsTouchWhenHighlighted = true
    }
    
    @IBAction func purpleButtonPressed(_ sender: Any) {
        color = 5.0
        purpleButton.showsTouchWhenHighlighted = true
    }
    
    @IBAction func redButtonPressed(_ sender: Any) {
        color = 6.0
        redButton.showsTouchWhenHighlighted = true
    }
    
    // MARK: - Methods
    
    func updatePlant() {
        guard let selectedPlant = plant, let plantName = plantNameTextField.text, let tagTitle = tagTitleTextField.text, let needsWateringDate = needsWateringDateValue, let tagColorNumber = color else {
           // PlantController.shared.createPlant(name: plantNameTextField.text ?? "Plant", image: , needsWaterFireDate: <#T##Date?#>, tagName: <#T##String?#>, colorNumber: <#T##Double#>)
            self.navigationController?.popViewController(animated: true)
            return
        }
        
    }
    
    func updateViews() {
        guard let selectedPlant = plant else { return }
        plantNameTextField.text = selectedPlant.name
        tagTitleTextField.text = selectedPlant.tag?.title
        
    }

}
