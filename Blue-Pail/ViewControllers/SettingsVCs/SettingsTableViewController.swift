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
    
    private var isDarkMode: Bool = false {
        didSet {
            self.tableView.reloadData()
            swapToDarkIfNeeded()
        }
    }
    // General Settings Labels & Image Keys:
    private let generalSettingLabels: [String] = [
        "Dark Mode"
    ]
    private let generalSettingIconKeys: [String] = [
        Keys.darkModeIcon
    ]
    // Support Settings Labels & Image Keys:
    // Removing FAQ for now - not enough question to begin with.
    private let supportSettingLabels: [String] = [
        "View Tutorial",
        //"FAQ"
    ]
    private let supportSettingIconKeys: [String] = [
        Keys.viewTutorialIcon,
        //Keys.FAQIcon
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
        
        // didChangeThemeModeNotification observer:
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeThemeMode), name: .didChangeThemeMode, object: nil)
        
        // Theme Setup:
        self.isDarkMode = DarkMode.shared.isDarkMode
    }
    
 

    // MARK: - TableView DataSource Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionLabels.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
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
                print ("ERROR: Failed instantiation of ToggleTableViewCell - check your cellForRowAt casting")
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
            toggleCell.setupCell(delegate: self, text: generalSettingLabels[indexPath.row], imageName: generalSettingIconKeys[indexPath.row], selected: selectedStatus, id: tableViewCellId)
            if isDarkMode {
                toggleCell.backgroundColor = .black
                toggleCell.mainTitleLabel.textColor = .white
            } else {
                toggleCell.backgroundColor = .white
                toggleCell.mainTitleLabel.textColor = .darkGrayBlue
            }
            //tableViewCellId += 1 // For setting up the next toggleCell identifier
            return toggleCell
        case 1: // Support Settings:
            guard let disclosureCell = tableView.dequeueReusableCell(withIdentifier: "disclosureTableViewCell", for: indexPath) as? DisclosureTableViewCell else {
                print("ERROR: Failed instantiation of disclosureTableViewCell - check your cellForRowAt cell casting")
                return UITableViewCell()
            }
            disclosureCell.settingLabel.text = supportSettingLabels[indexPath.row]
            disclosureCell.settingIconImageView.image = UIImage(named: supportSettingIconKeys[indexPath.row])
            if isDarkMode {
                disclosureCell.backgroundColor = .black
                disclosureCell.settingLabel.textColor = .white
            } else {
                disclosureCell.backgroundColor = .white
                disclosureCell.settingLabel.textColor = .darkGrayBlue
            }
            disclosureCell.selectionStyle = .none
            return disclosureCell
        case 2: // Sharing Settings:
            guard let disclosureCell = tableView.dequeueReusableCell(withIdentifier: "disclosureTableViewCell", for: indexPath) as? DisclosureTableViewCell else {
                print("ERROR: Failed instantiation of disclosureTableViewCell - check your cellForRowAt cell casting")
                return UITableViewCell()
            }
            disclosureCell.settingLabel.text = sharingSettingLabels[indexPath.row]
            disclosureCell.settingIconImageView.image = UIImage(named: sharingSettingIconKeys[indexPath.row])
            if isDarkMode {
                disclosureCell.backgroundColor = .black
                disclosureCell.settingLabel.textColor = .white
            } else {
                disclosureCell.backgroundColor = .white
                disclosureCell.settingLabel.textColor = .darkGrayBlue
            }
            disclosureCell.selectionStyle = .none  
            return disclosureCell
        default: // Defaulting to an empty cell:
            return UITableViewCell()
        }
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            if indexPath.row == 0 {
               self.performSegue(withIdentifier: "toTutorialTableView", sender: self)
            } 
        case 2:
            if indexPath.row == 0 {
                // User tapped the "Share" cell:
                let activityViewController = UIActivityViewController(activityItems: ["https://apps.apple.com/us/app/blue-pail/id1468522792?ls=1"], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            } else {
                //User tapped the "rate" cell:
                return
            }
        default:
           return
        }
    }
    
    // MARK: - Internal Methods
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let switchNib = UINib(nibName: "ToggleTableViewCell", bundle: nil)
        tableView.register(switchNib, forCellReuseIdentifier: "toggleTableViewCell")
    }
    
    #warning("Change the selected color to black for dark - white for light")
    /// Swaps the colors of all the elements in the view to their dark mode versions.
    func swapColorsToDark() {
        // Navigation Controller:
        NavigationBarHelper.setupDarkModeNavigationBar(viewController: self)
        self.navigationController?.navigationBar.barStyle = .black
        // TabBar Controller:
        self.tabBarController?.tabBar.barTintColor = .darkModeGray
        self.tabBarController?.tabBar.tintColor = .white
        // TableView:
        self.tableView.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
    }
    
    /// Swaps the colors of all the elements in the view to their defualt versions (light).
    func swapColorsToLight() {
        // TableView:
        self.tableView.backgroundColor = UIColor.darkModeGray
        // Navigation Controller:
        NavigationBarHelper.setupNativationBar(viewController: self)
        self.navigationController?.navigationBar.barStyle = .default
        // Tab Bar Controller:
        self.tabBarController?.tabBar.barTintColor = UIColor.mintGreen
        self.tabBarController?.tabBar.tintColor = UIColor.darkGrayBlue
        // TableView:
        self.tableView.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
    }
    
    /// Checks if the themeMode is set to true (i.e DarkMode enabled); If so, it calls swapColorsToDark to swap to dark mode colors.
    func swapToDarkIfNeeded() {
        if isDarkMode {
            swapColorsToDark()
        } else {
            swapColorsToLight()
        }
    }
    
    @objc private func didChangeThemeMode() {
        isDarkMode = UserDefaults.standard.bool(forKey: Keys.themeMode)
    }

}

// MARK: - ToggleValueChangedDelegate

extension SettingsTableViewController: ToggleValueChangedDelegate {
    func toggleValueChanged(selected: Bool, id: Int?) {
        if id == 1 {
            // This is the "Dark Mode" toggleCell:
            print("UserDefaults forKey themeMode set to \(selected)")
            UserDefaults.standard.set(selected, forKey: Keys.themeMode)
            // Post Notification:
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: .didChangeThemeMode, object: nil)
        }
    }
}
////if segue.identifier == "toEditPlant" {
//guard let detailVC = segue.destination as? PlantDetailTableViewController else { return }
//detailVC.plant = selectedPlant
//detailVC.navigationItem.title = selectedPlant?.name
//}
//}
