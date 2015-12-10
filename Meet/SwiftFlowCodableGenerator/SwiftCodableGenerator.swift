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

    let substructures = dictionary["key.substructure"] as? Array<XPCRepresentable>
    let actionableStructs = substructures?.filter(filterActionConvertibleStructs)

    return "\(actionableStructs)"
}

private func filterActionConvertibleStructs<T>(element: T) -> Bool {
    guard let dict = element as? Dictionary<String, XPCRepresentable> else { return false }
    guard let kind = dict["key.kind"] as? String where kind == "source.lang.swift.decl.struct" else { return false }

    let inheritedTypes = dict["key.inheritedtypes"] as? Array<XPCRepresentable>
    let isActionConvertible = inheritedTypes?.filter {
        if let value = (($0 as? Dictionary<String, XPCRepresentable>)?["key.name"]) as? String {
            if value == "GenerateCodable" {
                return true
            }
        }
        return false
    }.count > 0

    return isActionConvertible
}

