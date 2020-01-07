//
//  PickerViewTableViewCell.swift
//  Blue-Pail
//
//  Created by David Sadler on 12/30/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class PickerViewTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
