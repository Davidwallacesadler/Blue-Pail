//
//  VideoTableViewCell.swift
//  Blue-Pail
//
//  Created by David Sadler on 7/30/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

protocol PlayButtonPressedDelegate {
    func playButtonPressedForCellWith(id: Int?)
}

class VideoTableViewCell: UITableViewCell {
    
    // MARK: Internal Properties
    
    private var delegate: PlayButtonPressedDelegate?
    private var id: Int?
 
    // MARK: - Outlets
    #warning("Add a Play Button Graphic - Adjust the sizing of the cell")
    @IBOutlet weak var playButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func playVideoTapped(_ sender: Any) {
        delegate?.playButtonPressedForCellWith(id: id)
    }
    
    // MARK: - Methods
    
    func setupCell(delegate: PlayButtonPressedDelegate, id: Int) {
        self.delegate = delegate
        self.id = id
        self.selectionStyle = .none
    }
    
    
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
