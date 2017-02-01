//
//  Extensions.swift
//  Amaro
//
//  Created by John Lima on 01/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit

extension CGFloat {
    
    static func heightWithConstrainedWidth(string: String, width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
}

extension UIAlertController {
    
    static func createAlert(title: String? = nil, message: String? = nil, style: UIAlertControllerStyle, actions: [UIAlertAction]?, target: AnyObject?, isPopover: Bool = false, buttonItem: UIBarButtonItem? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        }
        
        if isPopover {
            alert.modalPresentationStyle = .popover
            let popover = alert.popoverPresentationController
            popover?.barButtonItem = buttonItem
            popover?.sourceRect = CGRect(x: 0, y: 10, width: 0, height: 0)
            popover?.backgroundColor = .white
        }
        
        target?.present(alert, animated: true, completion: nil)
    }
}

extension UILabel {
    
    
    /// Use this function to insert a horizontal line inside the label
    ///
    /// - Parameter color: The line color
    func addLine(color: UIColor = .white) {
        let line = UIView(frame: CGRect(x: 0, y: self.bounds.size.height/2, width: self.bounds.size.width, height: 1))
        line.backgroundColor = color
        self.addSubview(line)
    }
}

extension UIImageView {
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}

