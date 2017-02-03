//
//  Checkout.swift
//  Amaro
//
//  Created by John Lima on 02/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Foundation

fileprivate struct CheckoutKey {
    static let product = "product"
    static let size = "size"
    static let amount = "amount"
    static let price = "price"
    static let originPrice = "originPrice"
    static let originPricePromo = "originPricePromo"
}

class Checkout: NSObject, NSCoding {
    
    var product: Product?
    var size: Size?
    var amount: Int?
    var price: String?
    var originPrice: String?
    var originPricePromo: String?
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.product = aDecoder.decodeObject(forKey: CheckoutKey.product) as? Product
        self.size = aDecoder.decodeObject(forKey: CheckoutKey.size) as? Size
        self.amount = aDecoder.decodeInteger(forKey: CheckoutKey.amount)
        self.amount = aDecoder.decodeInteger(forKey: CheckoutKey.amount)
        self.price = aDecoder.decodeObject(forKey: CheckoutKey.price) as? String
        self.originPrice = aDecoder.decodeObject(forKey: CheckoutKey.originPrice) as? String
        self.originPricePromo = aDecoder.decodeObject(forKey: CheckoutKey.originPricePromo) as? String
    }
    
    convenience init(product: Product, size: Size, amount: Int, price: String, originPrice: String, originPricePromo: String?) {
        self.init()
        self.product = product
        self.size = size
        self.amount = amount
        self.price = price
        self.originPrice = originPrice
        self.originPricePromo = originPricePromo
    }
    
    func encode(with aCoder: NSCoder) {
        if let product = product { aCoder.encode(product, forKey: CheckoutKey.product) }
        if let size = size { aCoder.encode(size, forKey: CheckoutKey.size) }
        if let amount = amount { aCoder.encode(amount, forKey: CheckoutKey.amount) }
        if let price = price { aCoder.encode(price, forKey: CheckoutKey.price) }
        if let originPrice = originPrice { aCoder.encode(originPrice, forKey: CheckoutKey.originPrice) }
        if let originPricePromo = originPricePromo { aCoder.encode(originPricePromo, forKey: CheckoutKey.originPricePromo) }
    }
}

extension Checkout {
    
    static func addCheckout(object: Checkout, forKey: String) {
        
        var array = [Checkout]()
        
        if let data = getCheckoutSaved(forKey: forKey), data.count > 0 {
            array = data
            let duplicates = data.filter({ $0.product?.id == object.product?.id })
            if duplicates.count == 0 {
                array.append(object)
            }
        }else {
            array.append(object)
        }
        
        if array.count > 0 {
            let data = NSKeyedArchiver.archivedData(withRootObject: array)
            UserDefaults.standard.set(data, forKey: forKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func getCheckoutSaved(forKey: String) -> [Checkout]? {
        guard let data = UserDefaults.standard.data(forKey: forKey) else { return nil }
        let objects = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Checkout]
        return objects
    }
    
    static func removeCheckoutObject(forKey: String) {
        
    }
}
