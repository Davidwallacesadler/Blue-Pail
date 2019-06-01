//
//  pickerView.swift
//  Blue-Pail
//
//  Created by David Sadler on 5/31/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import UIKit

extension UIPickerView {
    
    // labels: [componentNumber: label]
    func setPickerLabels(labels: [Int: UILabel], containedView: UIView) {
        
        let fontSize: CGFloat = 17
        let labelWidth: CGFloat = containedView.bounds.width / CGFloat(self.numberOfComponents)
        let x: CGFloat = self.frame.origin.x
        let y: CGFloat = (self.frame.size.height / 2.0) - (fontSize / 2.0)
        
        for i in 0...self.numberOfComponents {
            
            if let label = labels[i] {
                if self.subviews.contains(label) {
                    label.removeFromSuperview()
                }
                // NEED TO FIX THE OFFSET THAT IS HAPPENING HERE
                label.frame = CGRect(x: x + labelWidth * CGFloat(i) - CGFloat(i + 28), y: y, width: labelWidth, height: fontSize)
                label.font = UIFont.systemFont(ofSize: fontSize)
                label.backgroundColor = .clear
                label.textAlignment = NSTextAlignment.center
                self.addSubview(label)
            }
        }
    }
}



