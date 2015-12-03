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

class InfoViewController: UIViewController, RoutableViewController {

    static let identifier = "InfoViewController"

    func pushRouteSegment(viewControllerIdentifier: ViewControllerIdentifier,
        completionHandler: RoutingCompletionHandler) -> RoutableViewController {

            abort()
    }

    func popRouteSegment(viewControllerIdentifier: ViewControllerIdentifier,
        completionHandler: RoutingCompletionHandler) {
            abort()
    }

    func changeRouteSegment(fromViewControllerIdentifier: ViewControllerIdentifier,
        toViewControllerIdentifier: ViewControllerIdentifier,
        completionHandler: RoutingCompletionHandler) -> RoutableViewController {

            abort()
    }

    @IBAction func cancelButtonTapped(sender: UIButton) {
        mainStore.dispatch(
            Action (
                type: ActionSetRoute,
                payload: ["route": ["TabBarViewController", StatsViewController.identifier]]
            )
        )
    }

}