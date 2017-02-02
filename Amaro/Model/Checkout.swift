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
    
    init?(product: Product, size: Size) {
        self.product = product
        self.size = size
    }
}
