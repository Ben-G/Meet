//
//  DataState.swift
//  Meet
//
//  Created by Benjamin Encz on 11/19/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlowPersistenceNSCoding

struct DataState: Coding {
    var contacts: [Contact] = []

    init() {}

    init?(dictionary: NSDictionary) {
        let array = dictionary["contacts"] as? NSArray
        contacts = array?.map { Contact(dictionary: $0 as! NSDictionary)! } ?? []
    }

    func dictionaryRepresentation() -> NSDictionary {
        let contactsArray = contacts.map { $0.dictionaryRepresentation() }
        return ["contacts": contactsArray]
    }
}

protocol HasDataState {
    var dataState: DataState { get set }
}
