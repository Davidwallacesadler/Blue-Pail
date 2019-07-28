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
    
    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Rounding corners:
        deleteTagButton.layer.cornerRadius = 6.0
        deleteTagButton.layer.borderWidth = 1.0
        deleteTagButton.layer.borderColor = UIColor.clear.cgColor
        deleteTagButton.layer.masksToBounds = true
        
        // NavigationBar Setup:
        NavigationBarHelper.setupNativationBar(viewController: self)
        
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
        swapColorThemeIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        swapColorThemeIfNeeded()
    }
    
    // MARK: - Properties
    
    var tagTitle: String?
    var tagColorNumber: Double?
    var tag: Tag?
    
    // MARK: - Outlets
    
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var deleteTagButton: UIButton!
    @IBOutlet weak var selectedColorLabel: UILabel!
    
    // MARK: - Actions
    
    // Save Button:
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
    
    // Cancel Button:
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
            self.navigationController?.popViewController(animated: true)
            return
        }
        let confirmDeletionAlert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete your '\(tagTitle)' tag? This will delete all the plants associated with this tag as well.", preferredStyle: .alert)
        confirmDeletionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        confirmDeletionAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: deleteTagPressed(action:)))
        self.present(confirmDeletionAlert, animated: true)
    }
    
    // MARK: - Internal Methods
    
    /// Deletes the selected tag if there was one passed in, and pops the viewController.
    func deleteTagPressed(action: UIAlertAction) {
        guard let tagToDelete = tag else {
            return
        }
        TagController.shared.deleteTag(selectedTag: tagToDelete)
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Updates the tagColorNumber property and updates the selectedColorView to reflect the selected color.
    private func updateColorChoice(colorID: Double) {
        tagColorNumber = colorID
        selectedColorView.backgroundColor = ColorHelper.colorFrom(colorNumber: colorID)
    }
   
    /// Updates the titleTextField, and the color view if there was a Tag passed in.
    private func updateElements() {
        guard let selectedTag = tag else { return }
        updateColorChoice(colorID: selectedTag.colorNumber)
        tagTextField.text = selectedTag.title
        self.navigationItem.title = selectedTag.title
    }
    
    func swapColorsToDark() {
        // Self:
        self.view.backgroundColor = UIColor.tableViewScetionDarkGray
        // Navigation Bar:
        NavigationBarHelper.setupDarkModeNavigationBar(viewController: self)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.mintGreen
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.mintGreen
        // TableView:
        // TableView Cells:
        #warning("Fix this loop => set a custom UIView with desired background color to the backgroundView property")
        for section in 0..<tableView.numberOfSections {
            let tableViewSection = tableView.headerView(forSection: section)
            tableViewSection?.tintColor = UIColor.tableViewScetionDarkGray
            tableViewSection?.textLabel?.textColor = UIColor.mintGreen
        }
        for view in self.tableView.subviews {
            view.backgroundColor = UIColor.darkGrayBlue
        }
        // Outlets:
        self.tagTextField.backgroundColor = UIColor.textFieldBackgroundGray
        self.tagTextField.textColor = UIColor.mintGreen
        let placeholderAttributes = [ NSAttributedString.Key.foregroundColor : UIColor.mintGreen]
        let placeholder = NSAttributedString(string: "Please enter a title...", attributes: placeholderAttributes)
        self.tagTextField.attributedPlaceholder = placeholder
        self.selectedColorLabel.textColor = UIColor.mintGreen
    }
    
    func swapColorsToLight() {
        // Self:
        self.view.backgroundColor = UIColor.white
        // Navigation Bar:
        NavigationBarHelper.setupNativationBar(viewController: self)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.darkGrayBlue
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.darkGrayBlue
        // TableView:
        self.tableView.backgroundColor = UIColor.white
        // TableView Cells:
        var i = 0
        while i < self.tableView.visibleCells.count {
            let cell = self.tableView.visibleCells[i]
            cell.backgroundColor = UIColor.white
            i += 1
        }
        // Outlets:
        self.tagTextField.backgroundColor = UIColor.white
        self.tagTextField.textColor = UIColor.darkGrayBlue
        let placeHolderAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        let placeholder = NSAttributedString(string: "Please enter a title...", attributes: placeHolderAttributes)
        self.tagTextField.attributedPlaceholder = placeholder
    }
    
    func swapColorThemeIfNeeded() {
        if UserDefaults.standard.bool(forKey: Keys.themeMode) {
            swapColorsToDark()
        } else {
            swapColorsToLight()
        }
    }
}

