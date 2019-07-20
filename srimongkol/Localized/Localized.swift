//
//  Localized.swift
//  srimongkol
//
//  Created by win on 20/7/19.
//  Copyright © 2019 Srimongkol. All rights reserved.
//

import Foundation

protocol LocalizedKey {
    var rawValue: String { get }
    var tableName: String { get }
}

enum AllKey: String, LocalizedKey, CaseIterable {
    case hello = "hello"
    var tableName: String { return "Localized" }
}

extension String {
    static func localized(key: LocalizedKey, _ arguments: CVarArg...) -> String {
        let string = key.rawValue.localized(table: key.tableName)
        if arguments.isEmpty {
            return string
        }
        else {
            return String(format: string, arguments: arguments)
        }
    }
    
    func localized(table: String, comment: String = "") -> String {
        let language = "en"
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: table, bundle: bundle ?? Bundle.main, value: "", comment: comment)
    }
}
