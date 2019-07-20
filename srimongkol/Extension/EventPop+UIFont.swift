//
//  EventPop+UIFont.swift
//  eventpop
//
//  Created by win on 21/8/18.
//  Copyright © 2018 EVENT POP CO., LTD. All rights reserved.
//


import UIKit

extension UIFont {
    class func availableFontNames() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
    }
}

enum FontSize {
    case title
    case h1
    case h2
    case h3
    case h4
    case h5
    case body
    case overline
    case small
    case custom(size: CGFloat)
    
    var value: CGFloat {
        switch self {
        case .title:
            return 30
        case .h1:
            return 30
        case .h2:
            return 24
        case .h3:
            return 20
        case .h4:
            return 18
        case .h5:
            return 16
        case .body:
            return 16
        case .overline:
            return 14
        case .small:
            return 12
        case .custom(let size):
            return size
        }
    }
}

class FontName {
    private let size: FontSize
    init(size: FontSize) {
        self.size = size
    }
    
    var medium: UIFont {
        return UIFont(name: "Eventpop-Medium", size: 20.0)!.withSize(size.value)
    }
    var bold: UIFont {
        return UIFont(name: "Eventpop-Bold", size: 20.0)!.withSize(size.value)
    }
}

extension UIFont {
    static var title = FontName(size: .title)
    static var h1 = FontName(size: .h1)
    static var h2 = FontName(size: .h2)
    static var h3 = FontName(size: .h3)
    static var h4 = FontName(size: .h4)
    static var h5 = FontName(size: .h5)
    static var body = FontName(size: .body)
    static var overline = FontName(size: .overline)
    static var small = FontName(size: .small)
    static func custom(size: CGFloat) -> FontName { return FontName(size: .custom(size: size)) }
    
    class func style(_ name: String) -> UIFont {
        let components = name.lowercased().components(separatedBy: ".")
        let size = components[0]
        let name = components[1]
        
        let fontName: FontName
        switch size {
            case "title":
                fontName = UIFont.title
            case "h1":
                fontName = UIFont.h1
            case "h2":
                fontName = UIFont.h2
            case "h3":
                fontName = UIFont.h3
            case "h4":
                fontName = UIFont.h4
            case "h5":
                fontName = UIFont.h5
            case "body":
                fontName = UIFont.body
            case "overline":
                fontName = UIFont.overline
            case "small":
                fontName = UIFont.small
            default:
                fatalError("Invalid font size")
        }
        
        switch name {
        case "medium":
            return fontName.medium
        case "bold":
            return fontName.bold
        default:
            fatalError("Invalid font name")
        }
    }
}
