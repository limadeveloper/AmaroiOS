//
//  CustomLabel.swift
//  Amaro
//
//  Created by John Lima on 02/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit

@IBDesignable
class CustomLabel: UILabel {

    @IBInspectable
    var rounded: CGFloat = 0 {
        didSet {
            layer.cornerRadius = rounded
            layer.masksToBounds = rounded > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}
