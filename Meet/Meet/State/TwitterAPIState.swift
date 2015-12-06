//
//  TwitterAPIState.swift
//  Meet
//
//  Created by Benjamin Encz on 11/20/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import Result
import SwifteriOS

struct TwitterAPIState {
    var swifter: Swifter?
    var userSearchText: String?
    var userSearchResults: Result<[TwitterUser], TwitterAPIError>?
}

protocol HasTwitterAPIState {
    var twitterAPIState: TwitterAPIState { get set }
}
