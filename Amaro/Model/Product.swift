//
//  Product.swift
//  Amaro
//
//  Created by John Lima on 01/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Gloss
import RealmSwift

fileprivate struct ProductKey {
    static let id = "id"
    static let products = "products"
    static let image = "image"
    static let name = "name"
    static let style = "style"
    static let codeColor = "code_color"
    static let colorName = "color"
    static let regularPrice = "regular_price"
    static let actualPrice = "actual_price"
    static let discountPercentage = "discount_percentage"
    static let installments = "installments"
    static let sizes = "sizes"
    static let price = "price"
    static let hasPromo = "hasPromo"
    static let pricePromo = "pricePromo"
    static let amount = "amount"
}

typealias ArrayProduct = Results<Product>

class Product: Object, Decodable {
    
    dynamic var id: String?
    dynamic var image: String?
    dynamic var name: String?
    dynamic var style: String?
    dynamic var codeColor: String?
    dynamic var colorName: String?
    dynamic var price: String?
    dynamic var hasPromo = false
    dynamic var pricePromo: String?
    dynamic var discountPercentage: String?
    dynamic var installments: String?
    dynamic var amount = 0
    var sizes = List<Size>()
    
    convenience required init?(json: JSON) {
        self.init()
        
        guard let name: String = ProductKey.name <~~ json, let style: String = ProductKey.style <~~ json, let codeColor: String = ProductKey.codeColor <~~ json else { return }
        
        self.name = name
        self.style = style
        self.codeColor = codeColor
        self.image = ProductKey.image <~~ json
        self.colorName = ProductKey.colorName <~~ json
        self.price = ProductKey.regularPrice <~~ json
        self.discountPercentage = ProductKey.discountPercentage <~~ json
        self.installments = ProductKey.installments <~~ json
        
        if let sizes: [Size] = ProductKey.sizes <~~ json, sizes.count > 0 {
            for size in sizes {
                self.sizes.append(size)
            }
        }
        
        self.id = Product.createId(name: name, style: style, codeColor: codeColor)
        
        if let discountPercentage = self.discountPercentage, !discountPercentage.isEmpty {
            self.pricePromo = ProductKey.actualPrice <~~ json
            self.hasPromo = self.pricePromo != nil
        }
    }
}

extension Product {
    
    static func createId(name: String, style: String, codeColor: String) -> String {
        let name = name.replacingOccurrences(of: " ", with: "")
        return "ID-\(name)-\(style)-\(codeColor)"
    }
    
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
