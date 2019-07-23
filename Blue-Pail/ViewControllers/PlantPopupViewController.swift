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
//        yourView.clipsToBounds = true
//        yourView.layer.cornerRadius = 10
//        yourView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
    }
    override func viewDidAppear(_ animated: Bool) {
//        self.editButton.layer.cornerRadius = 6.0
//        self.editButton.layer.borderWidth = 1.0
//        self.editButton.layer.borderColor = UIColor.clear.cgColor
//        self.editButton.clipsToBounds = true
//        self.editButton.layer.cornerRadius = 6.0
//        self.editButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner ]
        self.xButton.tintColor = UIColor.white
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var waterButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var xButton: UIImageView!
    
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
    @IBAction func backButtonPressed(_ sender: Any) {
        self.view.isHidden = true
        self.removeFromParent()
    }
}

