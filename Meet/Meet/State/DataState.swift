//
//  DataState.swift
//  Meet
//
//  Created by Benjamin Encz on 11/19/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow
import SwiftFlowPersistenceNSCoding

struct DataState: Coding {
    var contacts: [Contact] = []

    init() {}

    init(dictionary: [String : AnyObject]) {
        let array = dictionary["contacts"] as? NSArray
        contacts = array?.map { Contact(dictionary: $0 as! [String : AnyObject]) } ?? []
    }

    func dictionaryRepresentation() -> [String : AnyObject] {
        let contactsArray = contacts.map { $0.dictionaryRepresentation() }
        return ["contacts": contactsArray]
    }
}

protocol HasDataState {
    var dataState: DataState { get set }
}
