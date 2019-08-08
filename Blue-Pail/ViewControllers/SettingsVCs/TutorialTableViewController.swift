//
//  TutorialTableViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 7/30/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class TutorialTableViewController: UITableViewController {
    
    // MARK: - Internal Properties
    #warning("This is not getting switched on toggling of darkMode")
    private var isDarkMode: Bool = false {
        didSet {
            self.tableView.reloadData()
            swapColorThemeIfNeeded()
        }
    }
    private let sectionLabels: [String] = [
        "Creating A Plant",
        "Creating A Tag",
        "Watering Your Plants"
    ]
    var avPlayer: AVPlayer!
    var cellId = 1
    
    // MARK: - Actions
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Internal Methods
    
    /// Swaps the the colors of the onscreen elements to their dark versions.
    func swapColorsToDark() {
        // Self:
        self.view.backgroundColor = .black
        // Navigation Controller:
        NavigationBarHelper.setupDarkModeNavigationBar(viewController: self)
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        // TableView:
        self.tableView.backgroundColor = .black
    }
    
    /// Swaps the colors of all the elements in the view to their defualt versions (light).
    func swapColorsToLight() {
        NavigationBarHelper.setupNativationBar(viewController: self)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.darkGrayBlue
    }
    
    /// Checks UserDefaults for the current themeMode
    func swapColorThemeIfNeeded() {
        if isDarkMode {
            // Dark Mode Enabled:
            swapColorsToDark()
        } else {
            // Dark Mode Disabled:
            swapColorsToLight()
        }
        
    }
    
    /// Sets up the tableView Delegate/Datasource, also registers custom cell nibs.
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let videoNib = UINib(nibName: "VideoTableViewCell", bundle: nil)
        self.tableView.register(videoNib, forCellReuseIdentifier: "videoTableViewCell")
    }

    #warning("need some way of stopping the video to play another one")
    /// Plays the video based on the passed in video key.
    func playVideo(givenVideoKey: String) {
        let filepath: String? = Bundle.main.path(forResource: givenVideoKey, ofType: "mov")
        let fileURL = URL.init(fileURLWithPath: filepath!)
        avPlayer = AVPlayer(url: fileURL)
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPlayer
        #warning("Want the video to not take up the whole screen?")
        avPlayerController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        avPlayerController.showsPlaybackControls = true
        avPlayerController.player?.play()
        self.addChild(avPlayerController)
        avPlayerController.view.frame = self.view.bounds
        self.view.addSubview(avPlayerController.view)
        avPlayerController.didMove(toParent: self)
    }
    
    // MARK: - View Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        // didChangeThemeModeNotification observer:
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeThemeMode), name: .didChangeThemeMode, object: nil)
        
        // Theme Setup:
        self.isDarkMode = UserDefaults.standard.bool(forKey: Keys.themeMode)
    }
    
//    override func viewDidLayoutSubviews() {
//        self.isDarkMode = DarkMode.shared.isDarkMode    
//    }

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
        guard let videoCell = tableView.dequeueReusableCell(withIdentifier: "videoTableViewCell", for: indexPath) as? VideoTableViewCell else {
            print ("ERROR: Failed instantiation of VideoTableViewCell - check your cellForRowAt casting")
            return UITableViewCell()
        }
        videoCell.setupCell(delegate: self, id: cellId)
        cellId += 1
        if isDarkMode {
            videoCell.playButton.imageView?.tintColor = .white
            videoCell.backgroundColor = .black
        } else {
            videoCell.playButton.imageView?.tintColor = UIColor.deepBlue
            videoCell.backgroundColor = .white
        }
        return videoCell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = tableView.headerView(forSection: section)
        if isDarkMode {
            sectionHeaderView?.backgroundColor = .darkModeGray
            sectionHeaderView?.textLabel?.textColor = .white
            return sectionHeaderView
        } else {
            sectionHeaderView?.backgroundColor = .lightGray
            sectionHeaderView?.textLabel?.textColor = .black
            return sectionHeaderView
        }
    }
    
    @objc private func didChangeThemeMode() {
        isDarkMode = UserDefaults.standard.bool(forKey: Keys.themeMode)
    }
    
}

// MARK: - PlayButtonPressedDelegate Methods

#warning("Create 3 videos - edit them down to as short as possible. Figure out the best way to capture video")
extension TutorialTableViewController: PlayButtonPressedDelegate {
    func playButtonPressedForCellWith(id: Int?) {
        if id == 1 {
            // Play the create a plant media
            playVideo(givenVideoKey: Keys.createAPlant)
        } else if id == 2 {
            // Play the create a tag media
        } else if id == 3 {
            // Play the watering demonstration
        }
    }
    
}
