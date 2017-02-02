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
    
    fileprivate var tableData = [Any]()
    fileprivate let cellName = "cell"
    
    var checkout: Checkout?
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    // MARK: - Actions
    @IBAction fileprivate func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction fileprivate func pay() {
        
    }
    
    fileprivate func updateUI() {
        
        cartProductNameLabel.text = checkout?.product?.name
        
        cartProductPriceNameLabel.text = "\(Titles.price):"
        cartProductSizeNameLabel.text = "\(Titles.size):"
        cartProductAmountNameLabel.text = "\(Titles.amount):"
        
        cartProductSizeTextField.text = checkout?.size?.size
        
        let backgroundFooter = UIView(frame: .zero)
        cartTableView.tableFooterView = backgroundFooter
        cartTableView.backgroundColor = Color.dark
        
        guard let stringImage = checkout?.product?.image, let url = URL(string: stringImage) else { return }
        backgroundImageView.af_setImage(withURL: url)
        cartProductImageView.af_setImage(withURL: url)
        
        if #available(iOS 10.0, *) {
            backgroundImageView.addBlurEffect(style: .regular)
        }else {
            // Fallback on earlier versions
            backgroundImageView.addBlurEffect()
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
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
