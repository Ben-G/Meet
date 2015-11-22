//
//  TwitterAPIReducer.swift
//  Meet
//
//  Created by Benjamin Encz on 11/20/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwifteriOS

struct TwitterAPIReducer {
    
    func setTwitterClient(var state: AppState, swifter: Swifter) -> AppState {
        state.twitterAPIState.swifter = swifter
        
        return state
    }
    
}