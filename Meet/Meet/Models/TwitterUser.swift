//
//  TwitterUser.swift
//  Meet
//
//  Created by Benjamin Encz on 11/22/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation
import SwiftFlow
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

extension TwitterUser: Coding {

    init(dictionary: [String : AnyObject]) {
        self.username = dictionary["username"] as! String
        self.name = dictionary["name"] as! String

        let profilePictureURL = dictionary["profilePictureURL"] as! String

        if profilePictureURL != "null" {
            self.profilePictureURL = NSURL(string: profilePictureURL)!
        } else {
            self.profilePictureURL = nil
        }
    }

    func dictionaryRepresentation() -> [String : AnyObject] {
        return ["username": self.username, "name": self.name,
            "profilePictureURL": profilePictureURL ?? "null"]
    }

}
