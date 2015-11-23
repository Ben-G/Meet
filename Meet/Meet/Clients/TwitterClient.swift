//
//  TwitterClient.swift
//  TwitterLivestreamSwift
//
//  Created by Benjamin Encz on 1/25/15.
//  Copyright (c) 2015 Benjamin Encz. All rights reserved.
//

import Foundation
import Accounts
import SwifteriOS
import UIKit
import SSKeychain
import ReactiveCocoa
import Unbox

// TODO: Overhaul this

enum TwitterAuthenticationError: ErrorType {
    case NotAuthenticated
}

struct TwitterClient {
    
    static var cachedSwifter: Swifter?
    
    static func login() -> SignalProducer<Swifter, TwitterAuthenticationError> {
        let accountType = ACAccountStore().accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        let accountStore = ACAccountStore()
        
        return SignalProducer<Swifter, TwitterAuthenticationError> { observer, _ in
            
            if let cachedSwifter = self.cachedSwifter {
                observer.sendNext(cachedSwifter)
                observer.sendCompleted()
            }
            
            accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (t:Bool, e:NSError!) -> Void in
                
                let (consumerKey, consumerSecret) = Authentication.retrieveApplicationAuthPair()
                let nativeAccount = ACAccountStore().accountsWithAccountType(accountType).last as? ACAccount
                
                if let nativeAccount = nativeAccount {
                    let swifter = Swifter(account: nativeAccount)
                    observer.sendNext(swifter)
                } else if let (cachedKey, cachedSecret) = Authentication.retrieveOAuthAccessPair() {
                    let swifter = Swifter(consumerKey: consumerKey, consumerSecret: consumerSecret, oauthToken: cachedKey, oauthTokenSecret: cachedSecret)
                    self.cachedSwifter = swifter
                    observer.sendNext(swifter)
                } else {
                    let swifter = Swifter(consumerKey: consumerKey, consumerSecret: consumerSecret)

                    swifter.authorizeWithCallbackURL(NSURL(string: "swifter://success")!, success: { (accessToken, response) -> Void in
                        self.cachedSwifter = swifter
                        Authentication.saveOAuthAccessPair(OAuthAccessPair(key: accessToken!.key, secret: accessToken!.secret))
                         observer.sendNext(swifter)
                    }, failure: { (error) -> Void in
                        print(error)
                        observer.sendFailed(.NotAuthenticated)
                    }, openQueryURL: nil)
                }
            }
        }
    }
    
    static func findUsers(searchString: String) -> SignalProducer<[TwitterUser], TwitterAuthenticationError> {
        return SignalProducer { observer, disposables in
            login().startWithNext { swifter in
                swifter.getUsersSearchWithQuery(searchString, page: 0, count: 5, includeEntities: false, success: { (users) -> Void in
                    if let users = users {
                        let twitterUsers = users.map { TwitterUser(json: $0) }
                        observer.sendNext(twitterUsers)
                    }
                    }, failure: { (error) -> Void in
                        
                })
            }
        }
        
//        return login().map { swifter in
//            swifter.getUsersSearchWithQuery("benjaminencz", page: 0, count: 5, includeEntities: false,  success: { users in
//                return users
//                }, failure: { (error) -> Void in
//                    
//            }).start()
//        }
    }
    
}