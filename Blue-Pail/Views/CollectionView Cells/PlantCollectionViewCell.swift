//
//  PlantCollectionViewCell.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/7/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class PlantCollectionViewCell: UICollectionViewCell {

    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressWater))
        addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Methods
    
    @objc func longPressWater() {
        // NOW JUST NEED TO DELEGATE BACK TO THE VIEW CONTROLLER?
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var tagColorView: UIView!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var tagTitleLabel: UILabel!
    @IBOutlet weak var waterNotificationStatusLabel: UILabel!
    @IBOutlet weak var waterNotificationStatusImageView: UIImageView!
    @IBOutlet weak var tagNameIconImageView: UIImageView!
    @IBOutlet weak var detailsBackgroundView: UIView!
}
