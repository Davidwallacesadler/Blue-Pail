//
//  PlantPopupViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/26/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

protocol PopupDelegate: UICollectionViewController {
    func editPlant()
    func waterPlant()
    func fertilizePlant()
    func showPlantFertilizerHistory()
}

class PlantPopupViewController: UIViewController {
    
    // MARK: - Delegate Reference - Weak Association
    
    weak var delegate: PopupDelegate?
    var plantHasFertilizerReminder = false
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if !plantHasFertilizerReminder {
            fertilizeButton.isHidden = true
            viewFertilizerLogButton.isHidden = true
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var waterButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var xButton: UIImageView!
    @IBOutlet weak var fertilizeButton: UIButton!
    @IBOutlet weak var viewFertilizerLogButton: UIButton!
    
    
    // MARK: - Actions
    
    @IBAction func backgroundTapped(_ sender: Any) {
        self.view.isHidden = true
        self.removeFromParent()
    }
    @IBAction func waterButtonTapped(_ sender: Any) {
        delegate?.waterPlant()
        self.view.isHidden = true
        self.removeFromParent()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        delegate?.editPlant()
        self.view.isHidden = true
        self.removeFromParent()
    }
    @IBAction func fertilizeButtonTapped(_ sender: Any) {
        delegate?.fertilizePlant()
        self.view.isHidden = true
        self.removeFromParent()
    }
    @IBAction func fertilizerLogButtonTapped(_ sender: Any) {
        delegate?.showPlantFertilizerHistory()
        self.view.isHidden = true
        self.removeFromParent()
    }
    
//    @IBAction func backButtonPressed(_ sender: Any) {
//        self.view.isHidden = true
//        self.removeFromParent()
//    }
}

