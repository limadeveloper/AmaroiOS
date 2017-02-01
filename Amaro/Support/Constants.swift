//
//  Constants.swift
//  Amaro
//
//  Created by John Lima on 01/02/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit

let keyWindow = UIApplication.shared.keyWindow!

struct Color {
    static let dark = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
}

struct Font {
    
    fileprivate struct Name {
        static let defaultMedium = "AvenirNext-Medium"
        static let defaultBold = "AvenirNext-DemiBold"
    }
    
    struct Size {
        static let small: CGFloat = 14
        static let regular: CGFloat = 17
        static let Bigger: CGFloat = 38
    }
    
    static func defaultMedium(size: CGFloat) -> UIFont? {
        return UIFont(name: Name.defaultMedium, size: size)
    }
    
    static func defaultBold(size: CGFloat) -> UIFont? {
        return UIFont(name: Name.defaultBold, size: size)
    }
}

struct Segue {
    static let details = "details"
}

struct Codes {
    static let controllerNoFound = 1
}

struct Titles {
    static let error = "Erro"
    static let alert = "Alerta"
    static let price = "Preço"
    static let promoPrice = "Promoção"
    static let total = "Total"
    static let sizes = "Tamanhos"
    static let oldName = "De"
    static let newName = "Por"
}

struct Messages {
    static let controllerNoFound = "Erro (\(Codes.controllerNoFound)) ocorreu. \nIdentificador do controller não pode ser encontrado."
}

struct ButtonTitle {
    static let ok = "Ok"
}

enum JsonFile: String {
    case products = "products"
}
