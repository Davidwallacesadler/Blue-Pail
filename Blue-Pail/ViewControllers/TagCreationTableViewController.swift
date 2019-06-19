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
    
        // Rounding corners:
        deleteTagButton.layer.cornerRadius = 6.0
        deleteTagButton.layer.borderWidth = 1.0
        deleteTagButton.layer.borderColor = UIColor.clear.cgColor
        deleteTagButton.layer.masksToBounds = true
        
        // NavigationBar Setup:
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.darkGrayBlue,
             NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 18)!]
        
        // Gesture recognizer Setup:
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        // TextField Setup:
        tagTextField.delegate = self
        
        // Edit Setup:
        if tag != nil {
            updateElements()
        }
    
    }
    
    // MARK: - Properties
    
    var tagTitle: String?
    var tagColorNumber: Double?
    var tag: Tag?
    
    // MARK: - Outlets
    
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var deleteTagButton: UIButton!
    
    
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
        guard let selectedTag = tag else {
            if TagController.shared.IsTagUnique(givenTagTitle: newTagTitle) {
                TagController.shared.createTag(tagTitle: newTagTitle, colorNumber: newTagColorNumber)
                self.navigationController?.popViewController(animated: true)
                return
            } else {
                let nonUniqueCreationAlert = UIAlertController(title: "Tag Already Exists", message: "A tag already exists with the title you entered. Please enter a different title.", preferredStyle: .alert)
                nonUniqueCreationAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(nonUniqueCreationAlert, animated: true)
                return
            }
        }
        TagController.shared.updateTag(selectedTag: selectedTag, withNewTitle: newTagTitle, withNewColorNumber: newTagColorNumber)
        self.navigationController?.popViewController(animated: true)
       
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
    @IBAction func deleteTagButtonPressed(_ sender: Any) {
        guard let tagTitle = tag?.title else {
//            let noTagSelectedAlert = UIAlertController(title: "No Tag Selected", message: "Please select the tag you wish to delete in the previous screen.", preferredStyle: .alert)
//            noTagSelectedAlert.addAction(UIAlertAction(title: "Ok", style: .cancel))
//            self.present(noTagSelectedAlert, animated: true)
//            return
            self.navigationController?.popViewController(animated: true)
            return
        }
        let confirmDeletionAlert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete your '\(tagTitle)' tag? This will delete all the plants associated with this tag as well.", preferredStyle: .alert)
        confirmDeletionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        confirmDeletionAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: deleteTagPressed(action:)))
        self.present(confirmDeletionAlert, animated: true)
    }
    
    
    // MARK: - Internal Methods
    
    func deleteTagPressed(action: UIAlertAction) {
        guard let tagToDelete = tag else {
            return
        }
        TagController.shared.deleteTag(selectedTag: tagToDelete)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func updateColorChoice(colorID: Double) {
        tagColorNumber = colorID
        selectedColorView.backgroundColor = ColorHelper.colorFrom(colorNumber: colorID)
    }
   
    private func updateElements() {
        guard let selectedTag = tag else { return }
        updateColorChoice(colorID: selectedTag.colorNumber)
        tagTextField.text = selectedTag.title
        self.navigationItem.title = selectedTag.title
    }
}

