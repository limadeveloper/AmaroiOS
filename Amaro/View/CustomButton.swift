//
//  CustomButton.swift
//  Amaro
//
//  Created by John Lima on 01/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable
    var rounded: CGFloat = 0 {
        didSet {
            layer.masksToBounds = rounded > 0
            layer.cornerRadius = rounded
        }
    }
}
