//
//  TwitterAPIActionCreator.swift
//  Meet
//
//  Created by Benjamin Encz on 11/20/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwifteriOS

struct TwitterAPIActionCreator {
    
    func authenticateUser() -> ActionCreator {
        return { state, store in
            if state.twitterAPIState.swifter == nil {
                TwitterClient.login().observeNext { swifter in
                    store.dispatch { self.setTwitterClient(swifter) }
                }
            }
            
            return nil
        }
    }
    
    func setTwitterClient(swifter: Swifter) -> ActionCreator {
        return { _ in
            return .SetTwitterClient(swifter)
        }
    }
    
}