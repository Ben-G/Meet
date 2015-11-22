//
//  Authentication.swift
//  Meet
//
//  Created by Benjamin Encz on 11/20/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SSKeychain

typealias OAuthAccessPair = (key: String, secret: String)
typealias ApplicationAuthPair = (consumerKey: String, consumerSecret: String)

struct Authentication {
    
    private static let OAuthKeyConstant = "twitterOAuthAccessTokenKey"
    private static let OAuthSecretConstant = "twitterOAuthAccessTokenSecret"
    private static let OAuthAccountConstant = ""
    
    static func saveOAuthAccessPair(pair: OAuthAccessPair) {
        let (cachedKey, cachedSecret) = pair
        
        SSKeychain.setPassword(cachedKey, forService: OAuthKeyConstant, account: OAuthAccountConstant)
        SSKeychain.setPassword(cachedSecret, forService: OAuthSecretConstant, account: OAuthAccountConstant)
    }
    
    static func retrieveOAuthAccessPair() -> OAuthAccessPair? {
        let cachedKey = SSKeychain.passwordForService(OAuthKeyConstant, account: OAuthAccountConstant)
        let cachedSecret = SSKeychain.passwordForService(OAuthSecretConstant, account: OAuthAccountConstant)
        
        if let cachedKey = cachedKey, cachedSecret = cachedSecret {
            return OAuthAccessPair(key: cachedKey, secret: cachedSecret)
        } else {
            return nil
        }
    }
    
    static func retrieveApplicationAuthPair() -> ApplicationAuthPair {
        let twitterKeysDictionaryURL = NSBundle.mainBundle().URLForResource("TwitterKeys", withExtension: "plist")
        
        if twitterKeysDictionaryURL == nil {
            print("You need to add a TwitterKey.plist with your consumer key and secret!")
        }
        
        let keys = NSDictionary(contentsOfURL: twitterKeysDictionaryURL!)!
        
        return ApplicationAuthPair(consumerKey: keys["consumer_key"] as! String, consumerSecret: keys["consumer_secret"] as! String)
    }
    
}
