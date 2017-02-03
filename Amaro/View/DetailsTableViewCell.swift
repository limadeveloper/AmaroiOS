//
//  DetailsTableViewCell.swift
//  Amaro
//
//  Created by John Lima on 01/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//
// https://github.com/gmertk/GMStepper

import UIKit
import GMStepper

class DetailsTableViewCell: UITableViewCell, PickerViewDelegate, DetailsControllerDelegate {
    
    // MARK: - Properties
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var firstPriceNameLabel: UILabel!
    @IBOutlet fileprivate weak var firstPriceValueLabel: UILabel!
    @IBOutlet fileprivate weak var secondPriceNameLabel: UILabel!
    @IBOutlet fileprivate weak var secondPriceValueLabel: UILabel!
    @IBOutlet fileprivate weak var secondPriceNameLabelConstraintWidth: NSLayoutConstraint!
    @IBOutlet fileprivate weak var secondPriceValueLabelConstraintHorizontalSpace: NSLayoutConstraint!
    @IBOutlet fileprivate weak var sizeLabel: UILabel!
    @IBOutlet fileprivate weak var sizesTextField: CustomTextField!
    @IBOutlet fileprivate weak var amountNameLabel: UILabel!
    @IBOutlet fileprivate weak var amountStepperContainer: UIView!
    
    fileprivate var price: String?
    
    var productImage: UIImage?
    var originPrice: String?
    var originPromoPrice: String?
    
    var product: Product? {
        didSet {
            
            firstPriceNameLabel.text = "\(Titles.price):"
            secondPriceNameLabel.text = "\(Titles.price):"
            sizeLabel.text = "\(Titles.size):"
            amountNameLabel.text = "\(Titles.amount):"
            
            firstPriceValueLabel.text = product?.price
            secondPriceValueLabel.text = product?.pricePromo
            nameLabel.text = product?.name?.uppercased()
            
            setupWhenPromotion(product: product)
            
            var sizes: [String]? {
                guard var sizes = product?.sizes, sizes.count > 0 else { return nil }
                sizes = sizes.filter({ $0.available == true })
                let result = sizes.map({ $0.size ?? "" }).filter({ !$0.isEmpty }).sorted { $0 > $1 }
                return result
            }
            
            guard let options = sizes else { return }
            sizesTextField.inputView = PickerView(options: options, delegate: self, image: productImage)
            
            if sizesTextField.text == nil || sizesTextField.text == "" {
                sizesTextField.text = options.first
            }
            
            if product?.amount == nil || product?.amount == 0 {
                product?.amount = 1
            }
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
    
    // MARK: - Actions
    fileprivate func createCustomStepper() {
        
        let stepper = GMStepper(frame: amountStepperContainer.bounds)
        stepper.minimumValue = 1
        stepper.buttonsBackgroundColor = .darkGray
        stepper.buttonsFont = Font.defaultBold(size: Font.Size.regular)!
        stepper.labelBackgroundColor = Color.dark.withAlphaComponent(0.6)
        stepper.labelFont = Font.defaultMedium(size: Font.Size.regular)!
        stepper.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stepper.addTarget(self, action: #selector(stepperValueChanged(stepper:)), for: .valueChanged)
        
        amountStepperContainer.addSubview(stepper)
    }
    
    @objc fileprivate func stepperValueChanged(stepper: GMStepper) {
        
        var stringPrice = originPrice
        
        if Product.hasPromo(product: self.product) {
            stringPrice = originPromoPrice
        }
        
        guard let price = stringPrice, let priceValue = Double.currencyNumberFrom(string: price) else { return }
        
        let product = self.product
        let newPriceValue = priceValue * stepper.value
        
        if  let newPriceString = Double.currencyStringFrom(value: newPriceValue),
            let installments = product?.installments?.characters.first?.description,
            let installmentsValue = Double(installments),
            let value = Double.currencyStringFrom(value: newPriceValue / installmentsValue)  {
            
            let installmentsResult = "\(installments)x \(value)"
            
            product?.installments = installmentsResult
            product?.pricePromo = newPriceString
            
            if Product.hasPromo(product: product) {
                if let price = originPrice, let priceValue = Double.currencyNumberFrom(string: price) {
                    let newPriceValue = priceValue * stepper.value
                    product?.price = Double.currencyStringFrom(value: newPriceValue)
                }
            }else {
                product?.price = newPriceString
            }
        }
        
        product?.amount = Int(stepper.value)
        
        self.product = product
    }
    
    fileprivate func setupWhenPromotion(product: Product?) {
        
        if !Product.hasPromo(product: product) {
            
            firstPriceNameLabel.textColor = .white
            firstPriceNameLabel.font = Font.defaultMedium(size: Font.Size.regular)
            firstPriceValueLabel.textColor = .white
            firstPriceValueLabel.font = Font.defaultMedium(size: Font.Size.regular)
            
            price = product?.price
            
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
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        createCustomStepper()
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
    func detailsControllerGetCheckoutData() -> [Checkout]? {
        
        var result = [Checkout]()
        
        guard let product = product, let sizeName = sizesTextField.text, !sizeName.isEmpty else { return nil }
        guard let size = Size.getSizeFrom(name: sizeName, and: product), let price = price, let amount = product.amount, let originPrice = originPrice else { return nil }
        
        let checkout = Checkout(
            product: product,
            size: size,
            amount: amount, 
            price: price,
            originPrice: originPrice,
            originPricePromo: originPromoPrice
        )
        
        Checkout.addCheckout(object: checkout, forKey: Keys.checkout)
        
        guard let array = Checkout.getCheckoutSaved(forKey: Keys.checkout), array.count > 0 else { return nil }
        result = array
        
        return result
    }
}
