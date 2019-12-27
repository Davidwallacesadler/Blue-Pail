//
//  TagCreationViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 6/18/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class TagCreationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - PickerView DataSource
    
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
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if tagPickerTitles.isEmpty == false {
            let tagTitle = tagPickerTitles[row]
            let tag = TagController.shared.getSelectedTag(givenTagTitle: tagTitle)
            let title = NSAttributedString(string: tagTitle, attributes: [NSAttributedString.Key.foregroundColor: ColorHelper.colorFrom(colorNumber: tag.colorNumber)])
            return title
        }
        return nil
    }
    
    // MARK: - PickerView Delegate Methods
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if tagPickerTitles.isEmpty {
            return
        } else {
            let selectedTagTitle = tagPickerTitles[row]
            let tag = TagController.shared.getSelectedTag(givenTagTitle: selectedTagTitle)
            selectedTag = tag
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
        NavigationBarHelper.setupNativationBar(viewController: self)
        
        // Check if Tag Collection is empty:
        if tagPickerTitles.isEmpty == false {
            selectedTag = TagController.shared.getSelectedTag(givenTagTitle: tagPickerTitles[0])
            tagCollectionPickerView.selectRow(0, inComponent: 0, animated: false)
        }
        
        // didChangeThemeModeNotification observer:
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeThemeMode), name: .didChangeThemeMode, object: nil)
        
        // Theme Setup:
        self.isDarkMode = DarkMode.shared.isDarkMode
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tagCollectionPickerView.reloadComponent(0)
    }
    
    // MARK: - Stored Properties
    
    private var isDarkMode: Bool = false {
        didSet {
            swapColorThemeIfNeeded()
        }
    }
    var selectedTag: Tag?
    
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
    
    // MARK: - Outlets
    
    @IBOutlet weak var tagCollectionPickerView: UIPickerView!
    
    // MARK: - Methods
    
    /// Swaps the colors of all the elements in the view to their dark mode versions.
    func swapColorsToDark() {
        // Self:
        self.view.backgroundColor = .black
        // Navigation Controller:
        NavigationBarHelper.setupDarkModeNavigationBar(viewController: self)
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        self.navigationController?.navigationBar.barStyle = .black
        // Tab Bar:
        self.tabBarController?.tabBar.tintColor = .white
        self.tabBarController?.tabBar.barTintColor = .darkModeGray
    }
    
    /// Swaps the colors of all the elements in the view to their default (light) versions.
    func swapColorsToLight() {
        // Self:
        self.view.backgroundColor = UIColor.white
        // Navigation Bar:
        NavigationBarHelper.setupNativationBar(viewController: self)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.darkGrayBlue
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.darkGrayBlue
        self.navigationController?.navigationBar.barStyle = .default
        // Tab Bar:
        self.tabBarController?.tabBar.tintColor = UIColor.darkGrayBlue
        self.tabBarController?.tabBar.barTintColor = UIColor.mintGreen
    }
    
    /// Calls swapColorsToLight or swapColorsToDark depending on the set themeMode.
    func swapColorThemeIfNeeded() {
        if UserDefaults.standard.bool(forKey: Keys.themeMode) {
            swapColorsToDark()
        } else {
            swapColorsToLight()
        }
    }
    
    @objc private func didChangeThemeMode() {
        isDarkMode = UserDefaults.standard.bool(forKey: Keys.themeMode)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditTag" {
            guard let detailVC = segue.destination as? TagCreationTableViewController else { return }
            guard let tagToPass = selectedTag else {
                let noTagSelectedAlert = UIAlertController(title: "No Tag Selected", message: "Please select the tag you wish to edit.", preferredStyle: .alert)
                noTagSelectedAlert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self.present(noTagSelectedAlert, animated: true)
                return
            }
            detailVC.tag = tagToPass
        }
    }

}
