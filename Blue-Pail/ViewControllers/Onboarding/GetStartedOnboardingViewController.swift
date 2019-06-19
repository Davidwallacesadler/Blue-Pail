//
//  GetStartedOnboardingViewController.swift
//  Blue-Pail
//
//  Created by David Sadler on 6/18/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class GetStartedOnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 6.0
        nextButton.layer.borderWidth = 1.0
        nextButton.layer.borderColor = UIColor.clear.cgColor
        nextButton.layer.masksToBounds = true

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var nextButton: UIButton!
    
    

    /*
    // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
