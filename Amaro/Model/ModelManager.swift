//
//  ModelManager.swift
//  Amaro
//
//  Created by John Lima on 05/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//
// https://realm.io/docs/swift/latest/

import RealmSwift

class ModelManager {
    
    class func getRealm() -> Realm? {
        return try? Realm()
    }
    
    class func getRealmUrl() -> URL? {
        return ModelManager.getRealm()?.configuration.fileURL
    }
}
