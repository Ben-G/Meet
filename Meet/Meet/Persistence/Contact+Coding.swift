//
//  Contact+Coding.swift
//  Meet
//
//  Created by Benjamin Encz on 11/24/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation

protocol Coding {
    init?(dictionary: NSDictionary)
    func dictionaryRepresentation() -> NSDictionary
}

extension Contact: Coding {
    
    init?(dictionary: NSDictionary) {
        guard let emailAddress = dictionary["email"] as? String else { return nil }
        guard let identifier = dictionary["identifier"] as? Int else { return nil }
        
        self.emailAddress = emailAddress
        self.identifier = identifier
    }
    
    func dictionaryRepresentation() -> NSDictionary {
        return ["email": emailAddress, "identifier": identifier]
    }
    
}