//
//  Size.swift
//  Amaro
//
//  Created by John Lima on 01/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Gloss
import RealmSwift

fileprivate struct SizeKey {
    static let available = "available"
    static let size = "size"
    static let sku = "sku"
}

typealias ArraySize = Results<Size>
typealias ListSize = List<Size>

class Size: Object, Decodable {
    
    dynamic var available: Bool = true
    dynamic var size: String?
    dynamic var sku: String?
    
    convenience required init(json: JSON) {
        self.init()
        
        if let available: Bool = SizeKey.available <~~ json { self.available = available }
        
        self.size = SizeKey.size <~~ json
        self.sku = SizeKey.sku <~~ json
    }
}

extension Size {
    
    static func getSizeFrom(json: JSON) -> Size? {
        return Size(json: json)
    }
    
    static func getSizeFrom(name: String, and product: Product) -> Size? {
        let size = product.sizes.filter({ $0.size == name }).first
        return size
    }
}
