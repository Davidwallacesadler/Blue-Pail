//
//  ToggleTableViewCell.swift
//  Blue-Pail
//
//  Created by David Sadler on 7/24/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

protocol ToggleValueChangedDelegate {
    func toggleValueChanged(selected: Bool, id: Int?)
}

class ToggleTableViewCell: UITableViewCell {
    
    // MARK: - Internal Properties
    
    private var delegate: ToggleValueChangedDelegate?
    private var id: Int?
    
    // MARK: - Outlets
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var mainSwitch: UISwitch!
    
    // MARK: - Actions
    
    @IBAction func toggleValueChanged(_ sender: UISwitch) {
        delegate?.toggleValueChanged(selected: mainSwitch.isOn, id: id)
    }
    
    // MARK: - Methods
    
    func setupCell(delegate: ToggleValueChangedDelegate, text: String, imageName: String, selected: Bool, id: Int?) {
        self.delegate = delegate
        self.mainTitleLabel.text = text
        self.iconImageView.image = UIImage(named: imageName)
        mainSwitch.isOn = selected
        self.selectionStyle = .none
        self.id = id
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
