//
//  TagCreationTableViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 6/1/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class TagCreationTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - TextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBar Setup:
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.pailBlue,
             NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 18)!]
        
        // Gesture recognizer Setup:
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        // TextField Setup:
        tagTextField.delegate = self
    }
    
    // MARK: - Properties
    
    var tagTitle: String?
    var tagColorNumber: Double?
    
    // MARK: - Outlets
    
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var selectedColorView: UIView!
    
    
    // MARK: - Actions
    
    // Save Button
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let newTagTitle = tagTextField.text.nilIfEmpty else {
            let noTitleAlert = UIAlertController(title: "No Title Entered", message: "Please enter a title for your new tag.", preferredStyle: .alert)
            noTitleAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(noTitleAlert, animated: true)
            return
        }
        guard let newTagColorNumber = tagColorNumber else {
            let noColorAlert = UIAlertController(title: "No Color Selected", message: "Please tap a color that you want to use for your new tag.", preferredStyle: .alert)
            noColorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(noColorAlert, animated: true)
            return
        }
        if TagController.shared.IsTagUnique(givenTagTitle: newTagTitle) {
            TagController.shared.createTag(tagTitle: newTagTitle, colorNumber: newTagColorNumber)
            self.navigationController?.popViewController(animated: true)
        } else {
            let nonUniqueCreationAlert = UIAlertController(title: "Tag Already Exists", message: "A tag already exists with the title you entered. Please enter a different title.", preferredStyle: .alert)
            nonUniqueCreationAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(nonUniqueCreationAlert, animated: true)
        }

    }
    
    // Cancel Button
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Color Buttons:
    @IBAction func redButtonPressed(_ sender: Any) {
        updateColorChoice(colorID: 6.0)
    }
    
    @IBAction func redOrangeButtonPressed(_ sender: Any) {
        updateColorChoice(colorID: 7.0)
    }
    
    @IBAction func yellowOrangeButtonPressed(_ sender: Any) {
         updateColorChoice(colorID: 8.0)
    }
    
    @IBAction func yellowButtonPressed(_ sender: Any) {
         updateColorChoice(colorID: 9.0)
    }
    
    @IBAction func limeGreenButtonPressed(_ sender: Any) {
         updateColorChoice(colorID: 10.0)
    }
    
    @IBAction func greenButtonPressed(_ sender: Any) {
         updateColorChoice(colorID: 11.0)
    }
    
    @IBAction func tealButtonPressed(_ sender: Any) {
         updateColorChoice(colorID: 12.0)
    }
    
    @IBAction func blueButtonPressed(_ sender: Any) {
         updateColorChoice(colorID: 13.0)
    }
    
    @IBAction func darkBlueButtonPressed(_ sender: Any) {
         updateColorChoice(colorID: 14.0)
    }
    @IBAction func purpleButtonPressed(_ sender: Any) {
         updateColorChoice(colorID: 15.0)
    }
    @IBAction func magentaButtonPressed(_ sender: Any) {
         updateColorChoice(colorID: 16.0)
    }
    @IBAction func pinkButtonPressed(_ sender: Any) {
         updateColorChoice(colorID: 17.0)
    }
    
    // MARK: - Internal Methods
    
    private func updateColorChoice(colorID: Double) {
        tagColorNumber = colorID
        selectedColorView.backgroundColor = ColorHelper.colorFrom(colorNumber: colorID)
    }
}
