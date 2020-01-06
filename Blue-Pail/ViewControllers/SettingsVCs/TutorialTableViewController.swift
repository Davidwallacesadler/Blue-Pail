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

#warning("TODO: - Turn this viewController into a PageViewController and have each page be a viewController with an autoplaying video")
class TutorialTableViewController: UITableViewController {
    
    // MARK: - Internal Properties
    private let sectionLabels: [String] = [
        "Creating A Plant",
        "Creating A Tag",
        "Watering Your Plants"
    ]
    var avPlayer: AVPlayer?
    var avPlayerContr: AVPlayerViewController?
    var cellId = 1
    
    // MARK: - Actions
    @IBAction func doneButtonPressed(_ sender: Any) {
        if avPlayer?.currentItem == nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            avPlayer?.pause()
            avPlayer?.replaceCurrentItem(with: nil)
            avPlayerContr?.removeFromParent()
            avPlayerContr?.view.removeFromSuperview()
        }
    }
    
    // MARK: - Internal Methods
    
    /// Sets up the tableView Delegate/Datasource, also registers custom cell nibs.
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let videoNib = UINib(nibName: "VideoTableViewCell", bundle: nil)
        self.tableView.register(videoNib, forCellReuseIdentifier: "videoTableViewCell")
    }
    
    #warning("TODO: need some way of stopping the video to play another one")
    /// Plays the video based on the passed in video key.
    func playVideo(givenVideoKey: String) {
        let filepath: String? = Bundle.main.path(forResource: givenVideoKey, ofType: "mov")
        let fileURL = URL.init(fileURLWithPath: filepath!)
        avPlayer = AVPlayer(url: fileURL)
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPlayer
        avPlayerController.showsPlaybackControls = true
        avPlayerController.player?.play()
        self.addChild(avPlayerController)
        avPlayerController.view.frame = self.view.bounds
        self.view.addSubview(avPlayerController.view)
        avPlayerController.didMove(toParent: self)
        avPlayerContr = avPlayerController
    }
    
    // MARK: - View Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
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
        guard let videoCell = tableView.dequeueReusableCell(withIdentifier: "videoTableViewCell", for: indexPath) as? VideoTableViewCell else {
            print ("ERROR: Failed instantiation of VideoTableViewCell - check your cellForRowAt casting")
            return UITableViewCell()
        }
        videoCell.setupCell(delegate: self, id: cellId)
        cellId += 1
        return videoCell
    }
    
}

// MARK: - PlayButtonPressedDelegate Methods

extension TutorialTableViewController: PlayButtonPressedDelegate {
    func playButtonPressedForCellWith(id: Int?) {
        if id == 1 {
            // Play the create a plant media
            playVideo(givenVideoKey: Keys.createAPlantTutorialVideo)
        } else if id == 2 {
            // Play the create a tag media
            playVideo(givenVideoKey: Keys.createATagTutorialVideo)
        } else if id == 3 {
            // Play the watering demonstration
            playVideo(givenVideoKey: Keys.waterPlantTutorialVideo)
        }
    }
}
