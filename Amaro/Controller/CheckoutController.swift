//
//  CheckoutController.swift
//  Amaro
//
//  Created by John Lima on 02/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit

class CheckoutController: UIViewController {

    // MARK: - Properties
    var checkout: Checkout?
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        print("checkout data: \(checkout)")
    }
    
    // MARK: - Actions
    @IBAction fileprivate func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
