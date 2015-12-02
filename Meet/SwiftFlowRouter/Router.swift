//
//  Router.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwiftFlow

public typealias TransitionProvider = (String, to: String) -> RouteTransition
public typealias ViewControllerProvider = String -> UIViewController

public class Router: NSObject {
    var store: MainStore
    var transitionFrom: TransitionProvider
    var viewControllerProvider: ViewControllerProvider

    public let rootViewController: UITabBarController

    public init(store: MainStore, rootViewController: UITabBarController,
        transitionProvider: TransitionProvider, viewControllerProvider: ViewControllerProvider) {

        self.store = store
        self.rootViewController = rootViewController
        self.transitionFrom = transitionProvider
        self.viewControllerProvider = viewControllerProvider

        super.init()

        self.store.subscribe(self)
    }
}

extension Router: StoreSubscriber {
  public func newState(state: HasNavigationState) {

        if let fromViewController = state.navigationState.currentViewController,
            toViewController = state.navigationState.transitionToViewController {

                let transition: RouteTransition
                // TODO: Cleanup nil-coalescing workaround
                if case .Custom(let customPresentation) = state.navigationState.presentationType ?? .Default {
                    transition = customPresentation
                } else {
                    transition = transitionFrom(fromViewController, to: toViewController)
                }

                switch transition {
                case .TabBarSelect:
                    rootViewController.selectedViewController = viewControllerProvider(toViewController)
                    store.dispatch(
                        Action(
                            type: ActionCompleteNavigationTo,
                            payload: ["targetViewController": toViewController]
                        )
                    )
                case .Modal:
                    viewControllerProvider(fromViewController).presentViewController(viewControllerProvider(toViewController),
                        animated: true, completion: nil)
                    store.dispatch(
                        Action(
                            type: ActionCompleteNavigationTo,
                            payload: ["targetViewController": toViewController]
                        )
                    )
                case .Dismiss:
                    viewControllerProvider(toViewController).dismissViewControllerAnimated(true, completion: nil)
                    store.dispatch(
                        Action(
                            type: ActionCompleteNavigationTo,
                            payload: ["targetViewController": toViewController]
                        )
                    )
                case .Push:
                    rootViewController.navigationController?.pushViewController(viewControllerProvider(toViewController),
                        animated: true)

                    // TODO: remove default
                default: break
                }
        }
    }

}

public enum RouteTransition {
  case Push
  case Pop
  case TabBarSelect
  case Modal
  case Dismiss
  case None
}
