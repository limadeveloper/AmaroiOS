//
//  DetailsTableViewCell.swift
//  Amaro
//
//  Created by John Lima on 01/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell, PickerViewDelegate, DetailsControllerDelegate {
    
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var firstPriceNameLabel: UILabel!
    @IBOutlet fileprivate weak var firstPriceValueLabel: UILabel!
    @IBOutlet fileprivate weak var secondPriceNameLabel: UILabel!
    @IBOutlet fileprivate weak var secondPriceValueLabel: UILabel!
    @IBOutlet fileprivate weak var secondPriceNameLabelConstraintWidth: NSLayoutConstraint!
    @IBOutlet fileprivate weak var secondPriceValueLabelConstraintHorizontalSpace: NSLayoutConstraint!
    @IBOutlet fileprivate weak var sizeLabel: UILabel!
    @IBOutlet fileprivate weak var sizesTextField: CustomTextField!
    
    fileprivate var price: String?
    
    var productImage: UIImage?
    
    var product: Product? {
        didSet {
            
            firstPriceNameLabel.text = "\(Titles.price):"
            secondPriceNameLabel.text = "\(Titles.price):"
            sizeLabel.text = "\(Titles.size):"
            
            firstPriceValueLabel.text = product?.price
            secondPriceValueLabel.text = product?.pricePromo
            nameLabel.text = product?.name?.uppercased()
            
            price = product?.price
            
            if !Product.hasPromo(product: product) {
                
                firstPriceNameLabel.textColor = .white
                firstPriceNameLabel.font = Font.defaultMedium(size: Font.Size.regular)
                firstPriceValueLabel.textColor = .white
                firstPriceValueLabel.font = Font.defaultMedium(size: Font.Size.regular)
                
                secondPriceValueLabel.text = product?.installments
                
                secondPriceNameLabelConstraintWidth.constant = ConstraintValue.first
                secondPriceValueLabelConstraintHorizontalSpace.constant = ConstraintValue.first
                
            }else {
                
                // Has promotion
                
                firstPriceNameLabel.text = "\(Titles.oldName):"
                firstPriceNameLabel.textColor = .darkGray
                firstPriceNameLabel.font = Font.defaultMedium(size: Font.Size.small)
                firstPriceValueLabel.textColor = .darkGray
                firstPriceValueLabel.font = Font.defaultMedium(size: Font.Size.small)
                
                secondPriceNameLabel.text = "\(Titles.newName):"
                secondPriceNameLabelConstraintWidth.constant = ConstraintValue.second
                secondPriceValueLabelConstraintHorizontalSpace.constant = ConstraintValue.third
                
                price = product?.pricePromo
                
                guard let installments = product?.installments, !installments.isEmpty, let pricePromo = product?.pricePromo, !pricePromo.isEmpty else { return }
                secondPriceValueLabel.text = "\(pricePromo)  (\(installments))"
            }
            
            
            var sizes: [String]? {
                guard var sizes = product?.sizes, sizes.count > 0 else { return nil }
                sizes = sizes.filter({ $0.available == true })
                let result = sizes.map({ $0.size ?? "" }).filter({ !$0.isEmpty }).sorted { $0 > $1 }
                return result
            }
            
            guard let options = sizes else { return }
            sizesTextField.inputView = PickerView(options: options, delegate: self, image: productImage)
            sizesTextField.text = options.first
        }
    }
    
    var detailsController: DetailsController? {
        didSet {
            detailsController?.delegate = self
        }
    }
    
    fileprivate struct ConstraintValue {
        static let first: CGFloat = 0
        static let second: CGFloat = 50
        static let third: CGFloat = 8
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }
    
    // MARK: - PickerView Delegate
    func pickerView(value: String) {
        sizesTextField.text = value
        sizesTextField.resignFirstResponder()
    }
    
    func prickerViewDismiss() {
        sizesTextField.resignFirstResponder()
    }
    
    // MARK: - DetailsController Delegate
    func detailsControllerGetCheckoutData() -> Checkout? {
        guard let product = product, let sizeName = sizesTextField.text, !sizeName.isEmpty else { return nil }
        guard let size = Size.getSizeFrom(name: sizeName, and: product), let price = price else { return nil }
        let checkout = Checkout(product: product, size: size, amount: , price: price)
        return checkout
    }
}
