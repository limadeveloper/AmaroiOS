//
//  Checkout.swift
//  Amaro
//
//  Created by John Lima on 02/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Foundation
import RealmSwift
import Gloss

fileprivate struct CheckoutKey {
    static let product = "product"
    static let size = "size"
    static let amount = "amount"
    static let price = "price"
    static let originPrice = "originPrice"
    static let originPricePromo = "originPricePromo"
}

typealias ArrayCheckout = Results<Checkout>

class Checkout: Object {
    
    dynamic var product: Product?
    dynamic var size: Size?
    dynamic var amount = 0
    dynamic var price: String?
    dynamic var originPrice: String?
    dynamic var originPricePromo: String?
    
    convenience required init(product: Product, size: Size, amount: Int, price: String, originPrice: String, originPricePromo: String?) {
        self.init()
        self.product = product
        self.size = size
        self.amount = amount
        self.price = price
        self.originPrice = originPrice
        self.originPricePromo = originPricePromo
    }
}

extension Checkout {
    
    static func save(object: Checkout) {
        let model = ModelManager.getRealm()
        try! model.write {
            model.add(object)
        }
    }
    
    static func getObjects() -> ArrayCheckout? {
        let objects = ModelManager.getRealm().objects(Checkout.self)
        return objects
    }
    
    static func removeCheckoutObject(forKey: String) {
        
    }
}
