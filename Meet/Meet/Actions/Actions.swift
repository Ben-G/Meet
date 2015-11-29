//
//  Actions.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwifteriOS
import SwiftFlow

enum TwitterAPIAction: ActionType {
    case SetTwitterClient(Swifter)
    case SetUserSearchResults([TwitterUser])
}

enum DataMutationAction: ActionType {
    case CreateContactFromEmail(String)
    case DeleteContact(Int)
    case SetContacts([Contact])
}