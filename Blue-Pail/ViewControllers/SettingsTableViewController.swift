//
//  SettingsTableViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 7/24/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    // MARK: - Internal Properties
    
    // General Settings Labels & Image Keys:
    private let generalSettingLabels: [String] = [
        "Dark Mode"
    ]
    private let generalSettingIconKeys: [String] = [
        Keys.darkModeIcon
    ]
    // Support Settings Labels & Image Keys:
    private let supportSettingLabels: [String] = [
        "View Tutorial",
        "FAQ"
    ]
    private let supportSettingIconKeys: [String] = [
        Keys.viewTutorialIcon,
        Keys.FAQIcon
    ]
    // Support Settings Labels & Image Keys:
    private let sharingSettingLabels: [String] = [
        "Share",
        "Rate"
    ]
    private let sharingSettingIconKeys: [String] = [
        Keys.shareIcon,
        Keys.rateIcon
    ]
    // Section Labels:
    private let sectionLabels: [String] = [
        "General",
        "Support",
        "Sharing"
    ]
    private var tableViewCellId: Int = 1
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // TableView Setup:
        setupTableView()
        // NavigationBar Setup:
        NavigationBarHelper.setupNativationBar(viewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Theme Setup:
        swapToDarkIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        swapToDarkIfNeeded()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionLabels.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionLabels[section]
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // General Settings:
            guard let toggleCell = tableView.dequeueReusableCell(withIdentifier: "toggleTableViewCell", for: indexPath) as? ToggleTableViewCell else {
                print ("ERROR: Failed instantiation of ToggleTableViewCell - check you cellForRowAt cell casting")
                return UITableViewCell()
            }
            var selectedStatus: Bool {
                switch tableViewCellId {
                case 1:
                    return UserDefaults.standard.bool(forKey: Keys.themeMode)
                default:
                    return false
                }
            }
            print("Setting the 'Dark Mode' switch with userDefaults: \(selectedStatus)")
            toggleCell.setupCell(delegate: self, text: generalSettingLabels[indexPath.row], imageName: generalSettingIconKeys[indexPath.row], selected: selectedStatus, id: tableViewCellId)
            //tableViewCellId += 1 // For setting up the next toggleCell identifier
            return toggleCell
        case 1: // Support Settings:
            guard let disclosureCell = tableView.dequeueReusableCell(withIdentifier: "disclosureTableViewCell", for: indexPath) as? DisclosureTableViewCell else {
                print("ERROR: Failed instantiation of disclosureTableViewCell - check your cellForRowAt cell casting")
                return UITableViewCell()
            }
            disclosureCell.settingLabel.text = supportSettingLabels[indexPath.row]
            disclosureCell.settingIconImageView.image = UIImage(named: supportSettingIconKeys[indexPath.row])
            return disclosureCell
        case 2: // Sharing Settings:
            guard let disclosureCell = tableView.dequeueReusableCell(withIdentifier: "disclosureTableViewCell", for: indexPath) as? DisclosureTableViewCell else {
                print("ERROR: Failed instantiation of disclosureTableViewCell - check your cellForRowAt cell casting")
                return UITableViewCell()
            }
            disclosureCell.settingLabel.text = sharingSettingLabels[indexPath.row]
            disclosureCell.settingIconImageView.image = UIImage(named: sharingSettingIconKeys[indexPath.row])
            return disclosureCell
        default: // Defaulting to an empty cell:
            return UITableViewCell()
        }
    }
    
    // MARK: - Internal Methods
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let switchNib = UINib(nibName: "ToggleTableViewCell", bundle: nil)
        tableView.register(switchNib, forCellReuseIdentifier: "toggleTableViewCell")
    }
    
    func swapColorsToDark() {
        self.tableView.backgroundColor = UIColor.tableViewScetionDarkGray
        NavigationBarHelper.setupDarkModeNavigationBar(viewController: self)
        self.tabBarController?.tabBar.barTintColor = UIColor.darkGrayBlue
        self.tabBarController?.tabBar.tintColor = UIColor.mintGreen
        var i = 0
        while i < self.tableView.visibleCells.count {
            let cell = self.tableView.visibleCells[i]
            if let cellAsToggle = cell as? ToggleTableViewCell {
                cellAsToggle.mainTitleLabel.textColor = UIColor.mintGreen
            }
            if let cellAsDisclosure = cell as? DisclosureTableViewCell {
                cellAsDisclosure.settingLabel.textColor = UIColor.mintGreen
            }
            cell.backgroundColor = UIColor.darkGrayBlue
            i += 1
        }
    }
    
    func swapColorsToLight() {
        self.tableView.backgroundColor = UIColor.tableViewSectionGray
        NavigationBarHelper.setupNativationBar(viewController: self)
        self.tabBarController?.tabBar.barTintColor = UIColor.mintGreen
        self.tabBarController?.tabBar.tintColor = UIColor.darkGrayBlue
        var i = 0
        while i < self.tableView.visibleCells.count {
            let cell = self.tableView.visibleCells[i]
            // check if the cell is a toggle cell or a disclosure cell
            if let cellAsToggle = cell as? ToggleTableViewCell {
                cellAsToggle.mainTitleLabel.textColor = UIColor.darkGrayBlue
            }
            if let cellAsDisclosure = cell as? DisclosureTableViewCell {
                cellAsDisclosure.settingLabel.textColor = UIColor.darkGrayBlue
            }
            cell.backgroundColor = UIColor.white
            i += 1
        }
    }
    
    func swapToDarkIfNeeded() {
        let isDarkModeEnabled = UserDefaults.standard.bool(forKey: Keys.themeMode)
        if isDarkModeEnabled {
            swapColorsToDark()
        }
    }
    

}

// MARK: - ToggleValueChangedDelegate

extension SettingsTableViewController: ToggleValueChangedDelegate {
    func toggleValueChanged(selected: Bool, id: Int?) {
        if id == 1 {
            // This is the "Dark Mode" toggleCell:
            if selected {
                print("Dark Mode Enabled")
                swapColorsToDark()
            } else {
                print("Dark Mode Disabled")
                // Run SwapColorsToLight
                swapColorsToLight()
            }
            print("UserDefaults forKey themeMode set to \(selected)")
            UserDefaults.standard.set(selected, forKey: Keys.themeMode)
            
            // Run logic to swap colors with their "dark" versions -- look into how to do this.
        }
    }
}
