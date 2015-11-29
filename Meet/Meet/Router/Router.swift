//
//  Router.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwiftFlow
import SwiftFlowReactiveCocoaExtensions

public typealias TransitionProvider = (UIViewController, to: UIViewController) -> RouteTransition

public class Router: NSObject {
    var navigationActionCreator = NavigationActionCreator()
    var store: Store
    var transitionFrom: TransitionProvider
    
    public let rootViewController: UITabBarController
    
    public init(store: Store, rootViewController: UITabBarController, transitionProvider: TransitionProvider) {
        self.store = store
        self.rootViewController = rootViewController
        self.transitionFrom = transitionProvider
        
        super.init()
        
        rootViewController.delegate = self
        self.store.subscribe(self)
    }
}

extension Router: UITabBarControllerDelegate {
    
    public func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        store.dispatch( self.navigationActionCreator.navigateToViewController(viewController) )
        
        return false
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
                    rootViewController.selectedViewController = toViewController
                    store.dispatch(self.navigationActionCreator.navigateToViewControllerCompleted(toViewController))
                case .Modal:
                    fromViewController.presentViewController(toViewController, animated: true, completion: nil)
                    store.dispatch(self.navigationActionCreator.navigateToViewControllerCompleted(toViewController))
                case .Dismiss:
                    toViewController.dismissViewControllerAnimated(true, completion: nil)
                    store.dispatch(self.navigationActionCreator.navigateToViewControllerCompleted(toViewController))
                case .Push:
                    rootViewController.navigationController?.pushViewController(toViewController, animated: true)

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