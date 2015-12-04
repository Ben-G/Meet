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

    func pushRouteSegment(viewControllerIdentifier: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler) -> Routable {

            abort()
    }

    func popRouteSegment(viewControllerIdentifier: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler) {
            abort()
    }

    func changeRouteSegment(from: RouteElementIdentifier,
        to: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler) -> Routable {

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