//
//  Size.swift
//  Amaro
//
//  Created by John Lima on 01/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Gloss

fileprivate struct SizeKey {
    static let available = "available"
    static let size = "size"
    static let sku = "sku"
}

class Size: NSObject, NSCoding, Decodable {
    
    var available: Bool?
    var size: String?
    var sku: String?
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.available = aDecoder.decodeBool(forKey: SizeKey.available)
        self.size = aDecoder.decodeObject(forKey: SizeKey.size) as? String
        self.sku = aDecoder.decodeObject(forKey: SizeKey.sku) as? String
    }
    
    required convenience init(json: JSON) {
        self.init()
        self.available = SizeKey.available <~~ json
        self.size = SizeKey.size <~~ json
        self.sku = SizeKey.sku <~~ json
    }
    
    func encode(with aCoder: NSCoder) {
        if let available = available { aCoder.encode(available, forKey: SizeKey.available) }
        if let size = size { aCoder.encode(size, forKey: SizeKey.size) }
        if let sku = sku { aCoder.encode(sku, forKey: SizeKey.sku) }
    }
}

extension Size {
    
    static func getSizeFrom(json: JSON) -> Size? {
        return Size(json: json)
    }
    
    static func getSizeFrom(name: String, and product: Product) -> Size? {
        guard let sizes = product.sizes, sizes.count > 0 else { return nil }
        let size = sizes.filter({ $0.size == name }).first
        return size
    }
}
