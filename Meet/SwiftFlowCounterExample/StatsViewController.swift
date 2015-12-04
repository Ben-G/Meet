//
//  StatsViewController.swift
//  Meet
//
//  Created by Benjamin Encz on 12/1/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwiftFlow
import SwiftFlowRouter

class StatsViewController: UIViewController, Routable {

    static let identifier = "StatsViewController"

    var infoViewController: Routable!

    func pushRouteSegment(viewControllerIdentifier: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler) -> Routable {

            infoViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewControllerWithIdentifier("InfoViewController") as! Routable

            presentViewController(infoViewController as! UIViewController, animated: true,
                completion: completionHandler)

            return infoViewController
    }

    func popRouteSegment(identifier: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler) {

        dismissViewControllerAnimated(true, completion: completionHandler)
    }

    func changeRouteSegment(from: RouteElementIdentifier,
        to: RouteElementIdentifier,
        completionHandler: RoutingCompletionHandler) -> Routable {

            abort()
    }

    @IBAction func pushButtonTapped(sender: UIButton) {
        mainStore.dispatch(
            Action (
                type: ActionSetRoute,
                payload: ["route": ["TabBarViewController", StatsViewController.identifier,
                    InfoViewController.identifier]]
            )
        )
    }

}