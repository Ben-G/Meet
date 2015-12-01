//
//  TwitterUserTableViewCell.swift
//  Meet
//
//  Created by Benjamin Encz on 11/22/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import ListKit
import WebImage

class TwitterUserTableViewCell: UITableViewCell, ListKitCellProtocol {

    @IBOutlet var profilePictureImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!

    var model: TwitterUser? {
        didSet {
            nameLabel.text = model?.name
            usernameLabel.text = model?.username
            profilePictureImageView.sd_setImageWithURL(model?.profilePictureURL)
        }
    }

}
