//
//  PlantPopupViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/22/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

protocol PopupDelegate: UICollectionViewController {
    func editPlant()
    func waterPlant()
}

class PlantPopupViewController: UIViewController {
    
    // MARK: - Delegate Reference - Weak Association
    
    weak var delegate: PopupDelegate?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var waterButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    
    // MARK: - Actions
    
    @IBAction func waterButtonTapped(_ sender: Any) {
        delegate?.waterPlant()
        // want to dismiss the view
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        delegate?.editPlant()
        // want to segue to the detail view controller and pass the selected plant to the plant property
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
