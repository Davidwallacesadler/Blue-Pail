//
//  ButtonTableViewCell.swift
//  Blue-Pail
//
//  Created by David Sadler on 12/30/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

protocol ButtonCellDelegate {
    func buttonWasPressed(givenCellId: Int)
}

class ButtonTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var buttonTitle = ""
    var cellId: Int?
    var buttonBackgroundColor: UIColor = .clear
    var buttonBackgroundImage: UIImage?
    var buttonTitleLabelColor: UIColor = .systemBlue
    var delegate: ButtonCellDelegate?
    
    // MARK: - Outlets

    //MAKE SURE TO TAG THE BUTTON
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonImageView: UIImageView!
    
    // MARK: - Actions
    
    @IBAction func buttonPressed(_ sender: Any) {
        guard let cellDelegate = delegate, let id = cellId else { return }
        cellDelegate.buttonWasPressed(givenCellId: id)
    }
    
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        button.backgroundColor = buttonBackgroundColor
//        button.titleLabel?.textColor = buttonTitleLabelColor
//        button.titleLabel?.text = buttonTitle
//        if let image = buttonBackgroundImage {
//            buttonImageView.image = image
//        }
        ViewHelper.roundCornersOf(viewLayer: button.layer, withRoundingCoefficient: 5.0)
        ViewHelper.roundCornersOf(viewLayer: buttonImageView.layer, withRoundingCoefficient: 15.0)
    }
    
}
