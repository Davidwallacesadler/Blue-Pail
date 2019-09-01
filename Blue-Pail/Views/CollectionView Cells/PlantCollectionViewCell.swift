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
    
            // Fall back on longPress if force touch is not available:
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressWater))
            addGestureRecognizer(longPressGesture)
        #warning("Make a cell animation that is 1.25 sections that expands the cell is pressed and then shrinks it back as it waters")
     
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//            if self.traitCollection.forceTouchCapability == .available {
//                let cellLayer = self.contentView.layer
//                // Set the bounds (since they are animatable) to be a proportion of the force applied
//                let force = touch.force
//                let defaultCellBounds = cellLayer.bounds
//                let cellPostion = cellLayer.bounds.origin
//                let newHeightBasedOnForce = defaultCellBounds.size.height / force
//                let newWidthBasedOnForce = defaultCellBounds.size.width / force
//                let newCellBounds = CGRect(x: cellPostion.x, y: cellPostion.y, width: newWidthBasedOnForce, height: newHeightBasedOnForce)
//                self.contentView.layer.bounds = newCellBounds
//                if touch.force >= touch.maximumPossibleForce {
//                    // water and push cell in
//
//
//                }
//            }
//        }
//    }
    
    // MARK: - Methods
    
    @objc func longPressWater(sender: UILongPressGestureRecognizer) {
        guard let desiredIndexPath = indexPath else {
            return
        }
        if sender.state == .began {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
        // Animation Idea: when the longpress starts - start a timer and run the animation - any time durring if they cancel go back to normal. when the timer fires - the lenght of animation - run the water method. When it starts run the timer - call method that animates over the timer period. Timer and animation length match up and then call the selector. if the sender state is cancelled then cancel the animation.
        if sender.state == .ended {
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
