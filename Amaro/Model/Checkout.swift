//
//  Checkout.swift
//  Amaro
//
//  Created by John Lima on 02/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import RealmSwift

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
    
    static func save(object: Checkout) -> Bool {
        
        var saved = false
        let model = ModelManager.getRealm()
        
        try? model?.write {
            model?.add(object)
        }
        
        guard let objects = Checkout.getObjects(), objects.count > 0 else { return saved }
        let objectsSaved = objects.filter({ $0.product?.id == object.product?.id })
        
        saved = objectsSaved.count == 1
        
        return saved
    }
    
    static func getObjects() -> ArrayCheckout? {
        let objects = ModelManager.getRealm()?.objects(Checkout.self)
        return objects
    }
}
