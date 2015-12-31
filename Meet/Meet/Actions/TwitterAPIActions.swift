//
//  TwitterAPIActions.swift
//  Meet
//
//  Created by Benjamin Encz on 12/4/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwifteriOS
import SwiftFlow
import SwiftFlowRecorder
import Accounts
import Result

// MARK: Set User Search Text

struct SetUserSearchText: Action {
    static let type = "SetUserSearchText"
    let userSearchText: String

    init(_ userSearchText: String) {
        self.userSearchText = userSearchText
    }
}

// MARK: Set Twitter Client

struct SetTwitterClient {
    static let type = "SetTwitterClient"
    let twitterClient: Swifter

    init(_ twitterClient: Swifter) {
        self.twitterClient = twitterClient
    }
}

// MARK: Set User Search Result

struct SetUserSearchResult {
    static let type = "SetUserSearchResult"
    let userSearchResult: Result<[TwitterUser], TwitterAPIError>

    init(_ userSearchResult: Result<[TwitterUser], TwitterAPIError>) {
        self.userSearchResult = userSearchResult
    }
}

// MARK: Serialization Code

let TwitterAPIActionsTypeMap: TypeMap = [
    SetUserSearchText.type: SetUserSearchText.self,
    SetTwitterClient.type: SetTwitterClient.self,
    SetUserSearchResult.type: SetUserSearchResult.self
]

extension SetUserSearchText: StandardActionConvertible {

    init(_ action: StandardAction) {
        self.userSearchText = action.payload!["userSearchText"] as! String
    }

    func toStandardAction() -> StandardAction {
        return StandardAction(type: SetUserSearchText.type, payload: ["userSearchText": self.userSearchText], isTypedAction: true)
    }
    
}

extension SetTwitterClient: StandardActionConvertible {

    init(_ action: StandardAction) {
        self.twitterClient = decodeSwifter(action.payload!["swifter"] as! [String : AnyObject])
    }

    func toStandardAction() -> StandardAction {
        return StandardAction(type: SetTwitterClient.type,
            payload: ["swifter": encodeSwifter(twitterClient)])
    }
}

extension SetUserSearchResult: StandardActionConvertible {

    init(_ action: StandardAction) {
        self.userSearchResult = decode(action.payload!["userSearchResult"] as! [String : AnyObject])
    }

    func toStandardAction() -> StandardAction {
        return StandardAction(type: SetUserSearchResult.type,
            payload: ["userSearchResult": encode(userSearchResult)], isTypedAction: true)
    }
    
}
