//
//  AppDelegate.swift
//  SwiftFlowCounterExample
//
//  Created by Benjamin Encz on 12/1/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwiftFlow
import SwiftFlowRecorder
import SwiftFlowRouter

var mainStore = RecordingMainStore(reducer: MainReducer([CounterReducer(), NavigationReducer()]),
    appState: AppState(), recording: "recording.json")

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var router: Router!
    var window: UIWindow?

    var counterViewController: UIViewController!
    var statsViewController: UIViewController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let tabBarController = UITabBarController()
        counterViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewControllerWithIdentifier("CounterViewController")
        statsViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewControllerWithIdentifier("StatsViewController")

        tabBarController.viewControllers = [counterViewController, statsViewController]
        tabBarController.delegate = self

        router = Router(store: mainStore, rootViewController: tabBarController,
            transitionProvider: transitionFrom, viewControllerProvider: viewControllerProvider)

        mainStore.dispatch(
            Action (
                type: ActionSetNavigationState,
                payload: ["targetViewController": CounterViewController.identifier]
            )
        )

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = router.rootViewController
        window?.makeKeyAndVisible()

        return true
    }

    func transitionFrom(vc1: String, to vc2: String) -> RouteTransition {
        if (vc1 == StatsViewController.identifier) && (vc2 == CounterViewController.identifier) {
            return .TabBarSelect
        }

        if (vc1 == CounterViewController.identifier) && (vc2 == StatsViewController.identifier) {
            return .TabBarSelect
        }

        return .None
    }

    func viewControllerProvider(identifier: String) -> UIViewController {
        switch identifier {
        case CounterViewController.identifier:
            return counterViewController
        case StatsViewController.identifier:
            return statsViewController
        default:
            abort()
        }
    }

}

extension AppDelegate: UITabBarControllerDelegate {

    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        mainStore.dispatch(
            Action(
                type: ActionNavigateTo,
                payload: ["targetViewController": (viewController as! Routable)._identifier]
            )
        )

        return false
    }

}
