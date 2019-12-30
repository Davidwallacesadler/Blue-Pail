//
//  TextFieldTableViewCell.swift
//  Blue-Pail
//
//  Created by David Sadler on 12/30/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var textFieldPlaceHolder: String?

    // MARK: - Outlets
    
    // MAKE SURE TO SET THE TEXT FIELD DELEGATE IN THE VC AND SET IT AS ITS DELEGATE
    @IBOutlet weak var textField: UITextField!
    
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let placeHolderText = textFieldPlaceHolder {
            textField.placeholder = placeHolderText
        }
    }
    
}
