//
//  CustomView.swift
//  Amaro
//
//  Created by John Lima on 02/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit

@IBDesignable
class CustomView: UIView {
    
    @IBInspectable
    var rounded: CGFloat = 0 {
        didSet {
            layer.cornerRadius = rounded
        }
    }
}
    
