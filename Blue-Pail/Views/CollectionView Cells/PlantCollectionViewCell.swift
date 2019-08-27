//
//  PlantCollectionViewCell.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/7/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

protocol CollectionViewCellLongTouchDelegate {
    func didLongPress(index: IndexPath)
}

class PlantCollectionViewCell: UICollectionViewCell {
    
    var delegate: CollectionViewCellLongTouchDelegate?
    var indexPath: IndexPath?

    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressWater))
        addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Methods
    
    @objc func longPressWater(sender: UILongPressGestureRecognizer) {
        guard let desiredIndexPath = indexPath else {
            return
        }
        if sender.state == .began {
            delegate?.didLongPress(index: desiredIndexPath)
        }
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
