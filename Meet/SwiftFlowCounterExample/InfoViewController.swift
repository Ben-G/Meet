//
//  InfoViewController.swift
//  Meet
//
//  Created by Benjamin Encz on 12/2/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwiftFlow
import SwiftFlowRouter

class InfoViewController: UIViewController, Routable {

    static let identifier = "InfoViewController"

    @IBAction func cancelButtonTapped(sender: UIButton) {
        mainStore.dispatch(
            SetRouteAction(["TabBarViewController", StatsViewController.identifier])
        )
    }

}