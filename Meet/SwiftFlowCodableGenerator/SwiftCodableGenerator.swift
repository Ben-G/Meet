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

public func generateActionConvertible(input: File) -> [TypeSerializationInfo] {
    let structure = Structure(file: input)

    // key.kind struct, where key.inheritedtypes includes GenerateCodable
    let dictionary: XPCDictionary = structure.dictionary

    // Find structs implementing `StandardActionConvertible`
    let substructures = dictionary["key.substructure"] as? Array<XPCRepresentable>
    let actionableStructs = substructures?.filter(filterActionConvertibleStructs)

    let actionableTypeInfo = actionableStructs!.map {
        TypeSerializationInfo(dictionary: $0 as! XPCDictionary)
    }
    // Find all of their properties

    return actionableTypeInfo
}

private func filterActionConvertibleStructs<T>(element: T) -> Bool {
    guard let dict = element as? Dictionary<String, XPCRepresentable> else { return false }
    guard let kind = dict["key.kind"] as? String where kind == "source.lang.swift.decl.struct" else { return false }

    let inheritedTypes = dict["key.inheritedtypes"] as? Array<XPCRepresentable>
    let isActionConvertible = inheritedTypes?.filter {
        if let value = (($0 as? Dictionary<String, XPCRepresentable>)?["key.name"]) as? String {
            if value == "StandardActionConvertible" {
                return true
            }
        }
        return false
    }.count > 0

    return isActionConvertible
}

private func filterProperties<T>(element: T) -> Bool {
    guard let dict = element as? Dictionary<String, XPCRepresentable> else { return false }
    guard let kind = dict["key.kind"] as? String where kind == "source.lang.swift.decl.var.instance" else { return false }

    return true
}

//private func filterProperties

public struct TypeSerializationInfo {
    public var typeName: String
    public var properties: [PropertySerializationInfo] = []

    init(dictionary: XPCDictionary) {
        self.typeName = dictionary["key.name"] as! String

        let substructures = dictionary["key.substructure"] as? Array<XPCRepresentable>
        let properties = substructures?.filter(filterProperties)

        self.properties = properties!.map { PropertySerializationInfo(dictionary: $0 as! XPCDictionary) }
    }
}

public struct PropertySerializationInfo {
    public var propertyName: String
    public var propertyType: String

    init(dictionary: XPCDictionary) {
        self.propertyName = dictionary["key.name"] as! String
        self.propertyType = dictionary["key.typename"] as! String
    }
}