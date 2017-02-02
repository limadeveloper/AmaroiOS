//
//  Checkout.swift
//  Amaro
//
//  Created by John Lima on 02/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

struct Checkout {
    
    var product: Product?
    var size: Size?
    var amount: Int?
    var price: String?
    
    init?(product: Product, size: Size, amount: Int, price: String) {
        self.product = product
        self.size = size
        self.amount = amount
        self.price = price
    }
}
