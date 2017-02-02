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

struct Size: Decodable {
    
    var available: Bool?
    var size: String?
    var sku: String?
    
    init?(json: JSON) {
        self.available = SizeKey.available <~~ json
        self.size = SizeKey.size <~~ json
        self.sku = SizeKey.sku <~~ json
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
