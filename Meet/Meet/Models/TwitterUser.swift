//
//  TwitterUser.swift
//  Meet
//
//  Created by Benjamin Encz on 11/22/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwifteriOS

struct TwitterUser {

    let username: String
    let name: String
    let profilePictureURL: NSURL?

    init(json: JSONValue) {
        username = json.object?["screen_name"]?.string ?? "Unknown"
        name = json.object?["name"]?.string ?? "Unknown"
        let profilePictureURLString = json.object?["profile_image_url_https"]?.string

        if let profilePictureURLString = profilePictureURLString {
            profilePictureURL = NSURL(string: profilePictureURLString)
        } else {
            profilePictureURL = nil
        }
    }
}
