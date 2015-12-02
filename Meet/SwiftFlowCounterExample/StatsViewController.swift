//
//  StatsViewController.swift
//  Meet
//
//  Created by Benjamin Encz on 12/1/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwiftFlowRouter

class StatsViewController: UIViewController, RoutableViewController {

    static let identifier = "StatsViewController"

    func pushRouteSegment(viewControllerIdentifier: ViewControllerIdentifier) -> RoutableViewController {
        abort()
    }
    func popRouteSegment(viewControllerIdentifier: ViewControllerIdentifier) {
        abort()
    }
    func changeRouteSegment(fromViewControllerIdentifier: ViewControllerIdentifier,
        toViewControllerIdentifier: ViewControllerIdentifier) -> RoutableViewController {
            abort()
    }

}