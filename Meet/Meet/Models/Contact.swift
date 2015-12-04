//
//  Contact.swift
//  Meet
//
//  Created by Benjamin Encz on 11/19/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow
import SwiftFlowPersistenceNSCoding

struct Contact: Model {
    let identifier: Int
    var emailAddress: String? = nil
    var twitterHandle: String? = nil

    var displayName: String? {
        get {
            if let twitterHandle = twitterHandle {
                return twitterHandle
            } else if let emailAddress = emailAddress {
                return emailAddress
            }

            return nil
        }
    }

    init(identifier: Int, emailAddress: String) {
        self.identifier = identifier
        self.emailAddress = emailAddress
    }

    init(identifier: Int, twitterHandle: String) {
        self.identifier = identifier
        self.twitterHandle = twitterHandle
    }

}

extension Contact: Coding {

    init(dictionary: [String : AnyObject]) {
        let identifier = dictionary["identifier"] as! Int

        let emailAddress = dictionary["email"] as! String
        let twitterHandle = dictionary["twitterHandle"] as! String

        // Empty String equals nil in serialization for this type
        if twitterHandle == "" && emailAddress == "" { abort() }

        if twitterHandle == "" {
            self.twitterHandle = nil
        } else {
            self.twitterHandle = twitterHandle
        }

        if emailAddress == "" {
            self.emailAddress = nil
        } else {
            self.emailAddress = emailAddress
        }

        self.identifier = identifier
    }

    func dictionaryRepresentation() -> [String : AnyObject] {
        return [
            "email": self.emailAddress ?? "",
            "twitterHandle": self.twitterHandle ?? "",
            "identifier": identifier]
    }

}
