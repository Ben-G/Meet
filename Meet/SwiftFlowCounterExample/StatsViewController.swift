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

class StatsViewController: UIViewController, RoutableViewController {

    static let identifier = "StatsViewController"

    var infoViewController: RoutableViewController!

    func pushRouteSegment(viewControllerIdentifier: ViewControllerIdentifier,
        completionHandler: RoutingCompletionHandler) -> RoutableViewController {

            infoViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewControllerWithIdentifier("InfoViewController") as! RoutableViewController

            presentViewController(infoViewController as! UIViewController, animated: true,
                completion: completionHandler)

            return infoViewController
    }

    func popRouteSegment(viewControllerIdentifier: ViewControllerIdentifier,
        completionHandler: RoutingCompletionHandler) {

        dismissViewControllerAnimated(true, completion: completionHandler)
    }

    func changeRouteSegment(fromViewControllerIdentifier: ViewControllerIdentifier,
        toViewControllerIdentifier: ViewControllerIdentifier,
        completionHandler: RoutingCompletionHandler) -> RoutableViewController {

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