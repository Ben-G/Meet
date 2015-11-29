//
//  TwitterAPIActionCreator.swift
//  Meet
//
//  Created by Benjamin Encz on 11/20/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwifteriOS
import ReactiveCocoa
import SwiftFlow
import SwiftFlowReactiveCocoaExtensions

struct TwitterAPIActionCreator {
    
    var twitterClient = TwitterClient.self
    
    func authenticateUser() -> SignalAsyncActionCreator {
        return { maybeState, store in
            
            guard let state = maybeState as? AppState else { return nil }
        
            return Signal<ActionCreator, NoError> { observer in
                if state.twitterAPIState.swifter == nil {
                    
                    self.twitterClient.login().start { event in
                        switch event {
                        case let .Next(swifter):
                            observer.sendNext(self.setTwitterClient(swifter))
                        default:
                            print("oh")
                        }
                    }
                }
                
                return nil
            }
        }
    }
    
    func searchUsers(searchTerm: String) -> ActionCreator {
        return { state, store in
            
            self.twitterClient.findUsers(searchTerm).startWithNext { users in
                store.dispatch( TwitterAPIAction.SetUserSearchResults(users) )
            }
            
            return (action: nil)
        }
    }
    
    func setTwitterClient(swifter: Swifter) -> ActionCreator {
        return { _ in
            return TwitterAPIAction.SetTwitterClient(swifter)
        }
    }
    
}