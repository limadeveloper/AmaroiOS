//
//  CheckoutController.swift
//  Amaro
//
//  Created by John Lima on 02/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit
import AlamofireImage

class CheckoutController: UIViewController {

    // MARK: - Properties
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var backgroundImageView: UIImageView!
    @IBOutlet fileprivate weak var cartView: UIView!
    @IBOutlet fileprivate weak var cartTableView: UITableView!
    @IBOutlet fileprivate weak var cartProductImageView: UIImageView!
    @IBOutlet fileprivate weak var cartProductNameLabel: UILabel!
    @IBOutlet fileprivate weak var cartProductPriceNameLabel: UILabel!
    @IBOutlet fileprivate weak var cartProductSizeNameLabel: UILabel!
    @IBOutlet fileprivate weak var cartProductAmountNameLabel: UILabel!
    @IBOutlet fileprivate weak var cartProductPriceLabel: UILabel!
    @IBOutlet fileprivate weak var cartProductSizeTextField: CustomTextField!
    @IBOutlet fileprivate weak var cartProductAmountTextField: CustomTextField!
    @IBOutlet fileprivate weak var cartProductDetailContainerView: UIView!
    @IBOutlet fileprivate weak var cartProductDetailContainerViewConstraintTop: NSLayoutConstraint!
    @IBOutlet fileprivate weak var cartFinalButton: CustomButton!
    
    fileprivate var isDetailVisible = false
    fileprivate var tableData = [Any]()
    fileprivate let cellName = "cell"
    
    var checkout: Checkout?
    
    fileprivate struct ConstraintValue {
        static let first: CGFloat = 0
        static let second: CGFloat = -223
    }
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        updateUI()
    }
    
    // MARK: - Actions
    @IBAction fileprivate func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func getData() {
        
        guard let checkout = checkout else { return }
        tableData = [checkout]
    }
    
    fileprivate func updateUI() {
        
        hideProductDetail()
        updateFinalButtonTitle()
        
        cartProductPriceNameLabel.text = "\(Titles.price):"
        cartProductSizeNameLabel.text = "\(Titles.size):"
        cartProductAmountNameLabel.text = "\(Titles.amount):"
        
        if #available(iOS 10.0, *) {
            backgroundImageView.addBlurEffect(style: .regular)
        }else {
            // Fallback on earlier versions
            backgroundImageView.addBlurEffect()
        }
        
        let backgroundFooter = UIView(frame: .zero)
        cartTableView.tableFooterView = backgroundFooter
        cartTableView.backgroundColor = Color.dark
        cartTableView.reloadData()
    }
    
    fileprivate func updateFinalButtonTitle() {
        
        var title: String?
        
        if isDetailVisible {
            title = ButtonTitle.close
        }else {
            title = ButtonTitle.pay
        }
        
        cartFinalButton.setTitle(title, for: .normal)
    }
    
    @objc fileprivate func pay() {
        print("starting payment...")
    }
    
    @objc fileprivate func hideProductDetail() {
        
        cartProductDetailContainerViewConstraintTop.constant = ConstraintValue.second
        cartProductDetailContainerView.alpha = 0
        
        isDetailVisible = false
        
        updateFinalButtonTitle()
        cartFinalButton.addTarget(self, action: #selector(pay), for: .touchUpInside)
        
        getData()
        cartTableView.reloadData()
    }
    
    fileprivate func showProductDetail(indexPath: IndexPath) {
        
        cartProductDetailContainerViewConstraintTop.constant = ConstraintValue.first
        cartProductDetailContainerView.alpha = 1
        
        isDetailVisible = true
        
        updateFinalButtonTitle()
        cartFinalButton.addTarget(self, action: #selector(hideProductDetail), for: .touchUpInside)
        
        let checkout = tableData[indexPath.row] as? Checkout
        
        cartProductNameLabel.text = checkout?.product?.name
        cartProductPriceLabel.text = checkout?.price
        cartProductSizeTextField.text = checkout?.size?.size
        
        if let amount = checkout?.amount {
            cartProductAmountTextField.text = "\(amount)"
        }
        
        tableData = [Any]()
        cartTableView.reloadData()
        
        guard let stringImage = checkout?.product?.image, let url = URL(string: stringImage) else { return }
        backgroundImageView.af_setImage(withURL: url)
        cartProductImageView.af_setImage(withURL: url)
    }
    
    fileprivate func setupCheckoutCell(cell: UITableViewCell?, indexPath: IndexPath) {
        
        let photoImageView = cell?.viewWithTag(1) as? UIImageView
        let priceLabel = cell?.viewWithTag(2) as? UILabel
        let nameLabel = cell?.viewWithTag(3) as? UILabel
        
        let amountLabel = CustomLabel(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        amountLabel.borderColor = .white
        amountLabel.borderWidth = 1
        amountLabel.textColor = .white
        amountLabel.font = Font.defaultMedium(size: Font.Size.small)
        amountLabel.textAlignment = .center
        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.minimumScaleFactor = 0.8
        
        if  let checkout = tableData[indexPath.row] as? Checkout,
            let productName = checkout.product?.name,
            let price = checkout.price,
            let amount = checkout.amount {
            
            priceLabel?.text = price.uppercased()
            nameLabel?.text = productName.uppercased()
            amountLabel.text = "\(amount)"
            
            cell?.accessoryView = amountLabel
            
            guard let stringUrl = checkout.product?.image, let url = URL(string: stringUrl) else { return }
            photoImageView?.af_setImage(withURL: url)
        }else {
            cell?.accessoryView = nil
        }
    }
}

extension CheckoutController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)
        
        if !isDetailVisible {
            setupCheckoutCell(cell: cell, indexPath: indexPath)
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showProductDetail(indexPath: indexPath)
    }
}
