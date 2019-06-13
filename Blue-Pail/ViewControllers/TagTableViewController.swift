//
//  TagTableViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 6/10/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class TagTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if tagPickerTitles.isEmpty {
            return
        } else {
            let selectedTagTitle = tagPickerTitles[row]
            let tag = TagController.shared.getSelectedTag(givenTagTitle: selectedTagTitle)
            selectedTag = tag
            updateImageViewAndLabel()
        }
    }
    
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // PickerView Setup:
        self.tagCollectionPickerView.delegate = self
        self.tagCollectionPickerView.dataSource = self
        self.tagCollectionPickerView.reloadComponent(0)
        
        // NavigationBar Setup:
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.pailBlue,
             NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 18)!]
        
        selectedTag = nil
        updateImageViewAndLabel()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tagCollectionPickerView.reloadComponent(0)
        selectedTag = nil
        updateImageViewAndLabel()
        
    }
    
    // MARK - Properties
    
    var selectedTag: Tag?
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
    
    @IBOutlet weak var selectedTagColorView: UIView!
    @IBOutlet weak var selectedTagLabel: UILabel!
    @IBOutlet weak var tagCollectionPickerView: UIPickerView!
   
    // MARK: - Internal Methods
    
    private func updateImageViewAndLabel() {
        guard let tag = selectedTag else {
            selectedTagLabel.text = "Please select a tag"
            selectedTagColorView.backgroundColor = UIColor.gray
            return
        }
        selectedTagLabel.text = tag.title
        selectedTagColorView.backgroundColor = ColorHelper.colorFrom(colorNumber: tag.colorNumber)
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditTag" {
            guard let detailVC = segue.destination as? TagCreationTableViewController else { return }
            guard let tagToPass = selectedTag else {
                let noTagSelectedAlert = UIAlertController(title: "No Tag Selected", message: "Please select the tag you wish to delete.", preferredStyle: .alert)
                noTagSelectedAlert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self.present(noTagSelectedAlert, animated: true)
                return
            }
            detailVC.tag = tagToPass
        }
    }
}
