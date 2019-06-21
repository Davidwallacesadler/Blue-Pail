//
//  GetStartedOnboardingViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 6/18/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class GetStartedOnboardingViewController: UIViewController {
    
    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 6.0
        nextButton.layer.borderWidth = 1.0
        nextButton.layer.borderColor = UIColor.clear.cgColor
        nextButton.layer.masksToBounds = true
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var nextButton: UIButton!
}
