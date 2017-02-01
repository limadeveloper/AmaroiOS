//
//  HomeCollectionViewCell.swift
//  Amaro
//
//  Created by John Lima on 01/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet fileprivate weak var promoButton: UIButton!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var imageCoverView: UIView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var colorLabel: UILabel!
    @IBOutlet fileprivate weak var imageViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet fileprivate weak var titleLabelConstraintHeight: NSLayoutConstraint!
    
    var product: Product? {
        didSet {
            if let product = product {
                
                titleLabel.text = product.name?.uppercased()
                colorLabel.text = product.colorName?.uppercased()
                
                if let string = product.image, let url = URL(string: string) {
                    imageView.af_setImage(withURL: url)
                }
                
                guard let title = titleLabel.text else { return }
                let titleHeight = CGFloat.heightWithConstrainedWidth(string: title, width: titleLabel.frame.size.width, font: titleLabel.font)
                
                titleLabelConstraintHeight.constant = titleHeight + 12
                
                promoButton.isHidden = !Product.hasPromo(product: product)
            }
        }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let featuredHeight = UltraVisualLayoutConstants.Cell.featuredHeight
        let standardHeight = UltraVisualLayoutConstants.Cell.standardHeight
        
        let delta = 1 - ((featuredHeight - frame.height) / (featuredHeight - standardHeight))
        
        let minAlpha: CGFloat = 0.3
        let maxAlpha: CGFloat = 0.75
        
        imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
        
        let scale = max(delta, 0.5)
        titleLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        colorLabel.alpha = delta
        
        imageViewConstraintHeight.constant = featuredHeight
    }
}
