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

struct TwitterAPIActionCreator {
    
    var twitterClient = TwitterClient.self
    
    func authenticateUser() -> AsyncActionCreator {
        return { state, store in
        
            return Signal<ActionCreator, NoError> { observer in
                if state.twitterAPIState.swifter == nil {
                    self.twitterClient.login().observeNext { swifter in
                        observer.sendNext(self.setTwitterClient(swifter))
                    }
                }
                
                return nil
            }
        }
    }
    
    func setTwitterClient(swifter: Swifter) -> ActionCreator {
        return { _ in
            return .SetTwitterClient(swifter)
        }
    }
    
}