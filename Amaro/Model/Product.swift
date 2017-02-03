//
//  Product.swift
//  Amaro
//
//  Created by John Lima on 01/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Gloss

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

class Product: NSObject, NSCoding, Decodable {
    
    var id: String?
    var image: String?
    var name: String?
    var style: String?
    var codeColor: String?
    var colorName: String?
    var price: String?
    var hasPromo: Bool?
    var pricePromo: String?
    var discountPercentage: String?
    var installments: String?
    var sizes: [Size]?
    var amount: Int?
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.id = aDecoder.decodeObject(forKey: ProductKey.id) as? String
        self.image = aDecoder.decodeObject(forKey: ProductKey.image) as? String
        self.name = aDecoder.decodeObject(forKey: ProductKey.name) as? String
        self.style = aDecoder.decodeObject(forKey: ProductKey.style) as? String
        self.codeColor = aDecoder.decodeObject(forKey: ProductKey.codeColor) as? String
        self.colorName = aDecoder.decodeObject(forKey: ProductKey.colorName) as? String
        self.price = aDecoder.decodeObject(forKey: ProductKey.price) as? String
        self.hasPromo = aDecoder.decodeObject(forKey: ProductKey.hasPromo) as? Bool
        self.pricePromo = aDecoder.decodeObject(forKey: ProductKey.pricePromo) as? String
        self.discountPercentage = aDecoder.decodeObject(forKey: ProductKey.discountPercentage) as? String
        self.installments = aDecoder.decodeObject(forKey: ProductKey.installments) as? String
        self.amount = aDecoder.decodeObject(forKey: ProductKey.amount) as? Int
        self.sizes = aDecoder.decodeObject(forKey: ProductKey.sizes) as? [Size]
    }
    
    required convenience init?(json: JSON) {
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
        self.sizes = ProductKey.sizes <~~ json
        
        let codeName = name.replacingOccurrences(of: " ", with: "")
        self.id = Product.createId(name: codeName, style: style, codeColor: codeColor)
        
        if let discountPercentage = self.discountPercentage, !discountPercentage.isEmpty {
            self.pricePromo = ProductKey.actualPrice <~~ json
            self.hasPromo = self.pricePromo != nil
        }
    }
    
    func encode(with aCoder: NSCoder) {
        if let id = id { aCoder.encode(id, forKey: ProductKey.id) }
        if let image = image { aCoder.encode(image, forKey: ProductKey.image) }
        if let name = name { aCoder.encode(name, forKey: ProductKey.name) }
        if let style = style { aCoder.encode(style, forKey: ProductKey.style) }
        if let codeColor = codeColor { aCoder.encode(codeColor, forKey: ProductKey.codeColor) }
        if let colorName = colorName { aCoder.encode(colorName, forKey: ProductKey.colorName) }
        if let price = price { aCoder.encode(price, forKey: ProductKey.price) }
        if let hasPromo = hasPromo { aCoder.encode(hasPromo, forKey: ProductKey.hasPromo) }
        if let pricePromo = pricePromo { aCoder.encode(pricePromo, forKey: ProductKey.pricePromo) }
        if let discountPercentage = discountPercentage { aCoder.encode(discountPercentage, forKey: ProductKey.discountPercentage) }
        if let installments = installments { aCoder.encode(installments, forKey: ProductKey.installments) }
        if let amount = amount { aCoder.encode(amount, forKey: ProductKey.amount) }
        if let sizes = sizes { aCoder.encode(sizes, forKey: ProductKey.sizes) }
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
