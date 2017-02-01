//
//  Product.swift
//  Amaro
//
//  Created by John Lima on 01/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Gloss

fileprivate struct ProductKey {
    static let products = "products"
    static let image = "image"
    static let name = "name"
    static let colorName = "color"
    static let regularPrice = "regular_price"
    static let actualPrice = "actual_price"
    static let discountPercentage = "discount_percentage"
    static let installments = "installments"
    static let sizes = "sizes"
}

struct Product: Decodable {
    
    var image: String?
    var name: String?
    var colorName: String?
    var price: String?
    var hasPromo: Bool?
    var pricePromo: String?
    var discountPercentage: String?
    var installments: String?
    var sizes: [Size]?
    
    init?(json: JSON) {
        
        self.image = ProductKey.image <~~ json
        self.name = ProductKey.name <~~ json
        self.colorName = ProductKey.colorName <~~ json
        self.price = ProductKey.regularPrice <~~ json
        self.discountPercentage = ProductKey.discountPercentage <~~ json
        self.installments = ProductKey.installments <~~ json
        self.sizes = ProductKey.sizes <~~ json
        
        if let discountPercentage = self.discountPercentage, !discountPercentage.isEmpty {
            self.pricePromo = ProductKey.actualPrice <~~ json
            self.hasPromo = self.pricePromo != nil
        }
    }
}

extension Product {
    
    static func getProducts() -> [Product]? {
        
        guard let json = Requests.getDataFrom(file: .products)?.json as? JSON else { return nil }
        guard let products: [JSON] = ProductKey.products <~~ json else { return nil }
        
        var result = [Product]()
        
        if products.count > 0 {
            for json in products {
                guard let product = Product(json: json), let name = product.name, !name.isEmpty, let image = product.image, !image.isEmpty  else { continue }
                result.append(product)
            }
        }
        
        if result.count > 0 {
            return result
        }
        
        return nil
    }
    
    static func hasPromo(product: Product?) -> Bool {
        guard let hasPromo = product?.hasPromo else { return false }
        return hasPromo
    }
}
