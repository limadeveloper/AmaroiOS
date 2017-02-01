//
//  Requests.swift
//  Amaro
//
//  Created by John Lima on 01/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Foundation

class Requests {
    
    /// Use this function to get data from json file
    ///
    /// - Parameter file: json file name
    /// - Returns: json, error
    class func getDataFrom(file: JsonFile) -> (json: Any?, error: String?)? {
        guard let file = Bundle.main.path(forResource: file.rawValue, ofType: "json") else { return nil }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: file))
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return (json, nil)
        }catch {
            return (nil, error.localizedDescription)
        }
    }
}
