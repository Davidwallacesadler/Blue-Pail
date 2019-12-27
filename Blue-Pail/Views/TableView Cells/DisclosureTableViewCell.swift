//
//  DisclosureTableViewCell.swift
//  Blue-Pail
//
//  Created by David Sadler on 7/24/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class DisclosureTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var settingIconImageView: UIImageView!
    @IBOutlet weak var settingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
