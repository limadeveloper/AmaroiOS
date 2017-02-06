//: Playground - noun: a place where people can play

import UIKit

let array = [
    ["available": true, "size": "", "sku": "5807_343_0_G"],
    ["available": false, "size": "GG", "sku": "5807_343_0_GG"],
    ["available": false, "size": "PP", "sku": "5807_343_0_PP"],
    ["available": true, "size": "P", "sku": "5807_343_0_P"],
    ["available": true, "size": "M", "sku": "5807_343_0_M"]
]

let sizes = array.map({ $0["size"] as? String ?? "" }).filter({ !$0.isEmpty }).sorted { $0 > $1 }

print(sizes)

