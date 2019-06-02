//
//  TagCreationTableViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 6/1/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class TagCreationTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Properties
    
    var tagTitle: String?
    var tagColorNumber: Double?
    
    // MARK: - Outlets
    
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var selectedColorView: UIView!
    
    // MARK: - Actions
    
    // CRUD Buttons
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let newTagTitle = tagTextField.text, let newTagColorNumber = tagColorNumber else { return }
        //have a way of making sure the user is entering a unique tag
        TagController.shared.createTag(tagTitle: newTagTitle, colorNumber: newTagColorNumber)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Color Buttons
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
