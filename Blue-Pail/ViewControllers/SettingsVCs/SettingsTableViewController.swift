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
    // Removing FAQ for now - not enough question to begin with.
    private let supportSettingLabels: [String] = [
        "View Tutorials",
        //"FAQ"
    ]
    private let supportSettingIconKeys: [String] = [
        Keys.viewTutorialIcon,
        //Keys.FAQIcon
    ]
    // Support Settings Labels & Image Keys:
    private let sharingSettingLabels: [String] = [
        "Share",
    //    "Rate"
    ]
    private let sharingSettingIconKeys: [String] = [
        Keys.shareIcon,
    //    Keys.rateIcon
    ]
    // Section Labels:
    private let sectionLabels: [String] = [
        //"General",
        "Support",
        "Sharing"
    ]
    private var tableViewCellId: Int = 1
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // TableView Setup:
        setupTableView()
    }
    
 

    // MARK: - TableView DataSource Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionLabels.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionLabels[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // Support Settings:
            guard let disclosureCell = tableView.dequeueReusableCell(withIdentifier: "disclosureTableViewCell", for: indexPath) as? DisclosureTableViewCell else {
                print("ERROR: Failed instantiation of disclosureTableViewCell - check your cellForRowAt cell casting")
                return UITableViewCell()
            }
            disclosureCell.settingLabel.text = supportSettingLabels[indexPath.row]
            disclosureCell.settingIconImageView.image = UIImage(named: supportSettingIconKeys[indexPath.row])
            disclosureCell.selectionStyle = .none
            return disclosureCell
        case 1: // Sharing Settings:
            guard let disclosureCell = tableView.dequeueReusableCell(withIdentifier: "disclosureTableViewCell", for: indexPath) as? DisclosureTableViewCell else {
                print("ERROR: Failed instantiation of disclosureTableViewCell - check your cellForRowAt cell casting")
                return UITableViewCell()
            }
            disclosureCell.settingLabel.text = sharingSettingLabels[indexPath.row]
            disclosureCell.settingIconImageView.image = UIImage(named: sharingSettingIconKeys[indexPath.row])
            disclosureCell.selectionStyle = .none
            disclosureCell.accessoryType = .none
            return disclosureCell
        default: // Defaulting to an empty cell:
            return UITableViewCell()
        }
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
               self.performSegue(withIdentifier: "toTutorialTableView", sender: self)
            } 
        case 1:
            if indexPath.row == 0 {
                // User tapped the "Share" cell:
                let activityViewController = UIActivityViewController(activityItems: ["https://apps.apple.com/us/app/blue-pail/id1468522792?ls=1"], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                if UIDevice.current.userInterfaceIdiom == .phone {
                    self.present(activityViewController, animated: true, completion: nil)
                } else {
                    let popup = UIPopoverController(contentViewController: activityViewController)
                    popup.present(from: CGRect(x: self.view!.frame.size.width / 2, y: self.view!.frame.size.height / 4, width: 0, height: 0), in: self.view!, permittedArrowDirections: .any, animated: true)
                }
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
       // let switchNib = UINib(nibName: "ToggleTableViewCell", bundle: nil)
        //tableView.register(switchNib, forCellReuseIdentifier: "toggleTableViewCell")
    }
}

// MARK: - ToggleValueChangedDelegate

//extension SettingsTableViewController: ToggleValueChangedDelegate {
//    func toggleValueChanged(selected: Bool, id: Int?) {
//        if id == 1 {
//            // This is the "Dark Mode" toggleCell:
//            print("UserDefaults forKey themeMode set to \(selected)")
//            UserDefaults.standard.set(selected, forKey: Keys.themeMode)
//            // Post Notification:
//            let notificationCenter = NotificationCenter.default
//            notificationCenter.post(name: .didChangeThemeMode, object: nil)
//        }
//    }
//}
