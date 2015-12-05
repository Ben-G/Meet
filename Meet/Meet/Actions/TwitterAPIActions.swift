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
import Accounts
import Result

// MARK: Set Twitter Client

struct SetTwitterClient {
    static let type = "SetTwitterClient"
    let twitterClient: Swifter

    init(_ twitterClient: Swifter) {
        self.twitterClient = twitterClient
    }
}

extension SetTwitterClient: ActionConvertible {

    init(_ action: Action) {
        self.twitterClient = decodeSwifter(action.payload!["swifter"] as! [String : AnyObject])
    }

    func toAction() -> Action {
        return Action(type: SetTwitterClient.type,
            payload: ["swifter": encodeSwifter(twitterClient)])
    }
}

func encodeSwifter(swifter: Swifter) -> [String : AnyObject] {
    if let nativeAccountIdentifier = swifter.client.credential?.account?.identifier {
        return ["nativeAccount": nativeAccountIdentifier]
    } else if let key = swifter.client.credential?.accessToken?.key,
        secret = swifter.client.credential?.accessToken?.secret {
        return ["oAuth": ["key": key, "secret": secret]]
    } else {
        abort()
    }
}

// Fallback: Try to decode Swifter using info from toolchain
func decodeSwifter(dictionary: [String : AnyObject]) -> Swifter {
    if let nativeAccountIdentifier = dictionary["nativeAccount"] as? String {
        let nativeAccount = ACAccountStore().accountWithIdentifier(nativeAccountIdentifier)

        return Swifter(account: nativeAccount)

    } else if let oAuthCredentials = dictionary["oAuth"] {
        let key = oAuthCredentials["key"] as! String
        let secret = oAuthCredentials["secret"] as! String

        return Swifter(consumerKey: key, consumerSecret: secret)
    } else {
        abort()
    }
}

// MARK: Set User Search Result

//    case SetUserSearchResults(Result<[TwitterUser], TwitterAPIError>)

struct SetUserSearchResult {
    static let type = "SetUserSearchResult"
    let userSearchResult: Result<[TwitterUser], TwitterAPIError>

    init(_ userSearchResult: Result<[TwitterUser], TwitterAPIError>) {
        self.userSearchResult = userSearchResult
    }
}

extension SetUserSearchResult: ActionConvertible {

    init(_ action: Action) {
        self.userSearchResult = decode(action.payload!["userSearchResult"] as! [String : AnyObject])
    }

    func toAction() -> Action {
        return Action(type: SetUserSearchResult.type,
            payload: ["userSearchResult": encode(userSearchResult)])
    }

}

func encode<A: Coding, B: Coding>(x: Result<A, B>) -> [String : AnyObject] {
    switch x {
    case .Success(let t):
        return ["success": t.dictionaryRepresentation()]
    case .Failure(let e):
        return ["error": e.dictionaryRepresentation()]
    }
}

func encode<A: Coding, B: Coding>(x: Result<[A], B>) -> [String : AnyObject] {
    switch x {
    case .Success(let t):
        return ["success": t.map { $0.dictionaryRepresentation() }]
    case .Failure(let e):
        return ["error": e.dictionaryRepresentation()]
    }
}

func decode<A: Coding, B: Coding>(dictionary: [String : AnyObject]) -> Result<[A], B> {
    if let success = dictionary["success"] as? [AnyObject] {
        return .Success( success.map { A(dictionary: $0 as! [String : AnyObject]) } )
    } else if let failure = dictionary["failure"] as? [String : AnyObject] {
        return .Failure(B(dictionary: failure))
    } else {
        abort()
    }
}

func decode<A: Coding, B: Coding>(dictionary: [String : AnyObject]) -> Result<A, B> {
    if let success = dictionary["success"] as? [String : AnyObject] {
        return .Success(A(dictionary: success))
    } else if let failure = dictionary["failure"] as? [String : AnyObject] {
        return .Failure(B(dictionary: failure))
    } else {
        abort()
    }
}
