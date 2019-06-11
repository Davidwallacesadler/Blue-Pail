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
}

class PlantPopupViewController: UIViewController {
    
    // MARK: - Delegate Reference - Weak Association
    
    weak var delegate: PopupDelegate?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var waterButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    // MARK: - Actions
    
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
    @IBAction func backButtonPressed(_ sender: Any) {
        self.view.isHidden = true
        self.removeFromParent()
    }
}

