//
//  Swifter+Encoding.swift
//  Meet
//
//  Created by Benji Encz on 12/31/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow
import SwifteriOS
import Accounts

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