//
//  PlantCollectionViewCell.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/7/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class PlantCollectionViewCell: UICollectionViewCell {
    
    func moveSelectedBorderTo(selectedButton button: UIButton) {
        
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var tagColorView: UIView!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var tagTitleLabel: UILabel!
    
}
