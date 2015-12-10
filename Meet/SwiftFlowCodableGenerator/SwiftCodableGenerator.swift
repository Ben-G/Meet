//
//  SwiftCodableGenerator.swift
//  Meet
//
//  Created by Benjamin Encz on 12/9/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SourceKittenFramework
import SwiftXPC

public func generateActionConvertible(input: File) -> String {
    let structure = Structure(file: input)

    // key.kind struct, where key.inheritedtypes includes GenerateCodable
    let dictionary: XPCDictionary = structure.dictionary
    let keypath: [String] = ["key.substructure", "key.kind"]

    let result = WHERE(keypath, dictionary: dictionary, value: "struct")

    return "\(dictionary)"
}

protocol GetAnyable {
     func getAny(key: Any) -> Any?
}

extension Dictionary: GetAnyable {
    func getAny(key: Any) -> Any? {
        guard let correctKey = key as? Dictionary.Key else { return nil }
        return self[correctKey] as Any
    }
}

func WHERE<QueryKey: Hashable, QueryValue: Equatable, ValueType: Any>(keyPath: [QueryKey],
    dictionary: Dictionary<QueryKey, ValueType>, value: QueryValue) -> Dictionary<QueryKey, ValueType>? {

    var results: [Any] = []
    var subdictionary: Any = dictionary

    for key in keyPath {
        if let dict = subdictionary as? GetAnyable, let value = dict.getAny(key) {
            subdictionary = value
            results.append(value)
        } else if let array = subdictionary as? [GetAnyable] {
            let getAnyable = array.flatMap { $0.getAny(key)  }
            print("many")
        } else {
            return nil
        }
    }

    if let returnValue = subdictionary as? QueryValue where returnValue == value {
        return results[results.endIndex - 2] as? Dictionary<QueryKey, ValueType>
    } else {
        return nil
    }

}