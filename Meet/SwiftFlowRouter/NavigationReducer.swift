//
//  NavigationReducer.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwiftFlow

public struct NavigationReducer: Reducer {

    public init() {}

    public func handleAction(state: HasNavigationState, action: Action) -> HasNavigationState {
        switch action.type {
        case ActionSetNavigationState:
            return setNavigationState(state, targetViewController: action.payload!["targetViewController"]! as! String)
        case ActionNavigateTo:
            return navigateToViewController(state, targetViewController: action.payload!["targetViewController"]! as! String)
        case ActionCompleteNavigationTo:
            return completeNavigationToViewController(state, completedTransitionViewController: action.payload!["targetViewController"]! as! String)
        case ActionPresentViewController: break
//            return presentViewController(state, targetViewController: viewController)
        case ActionDismissViewController: break
//            return dismissViewController(state, parentViewController: viewController)
        default:
            break
        }

        return state
    }

    func navigateToViewController(var state: HasNavigationState, targetViewController: String) -> HasNavigationState {
        state.navigationState.transitionToViewController = targetViewController

        return state
    }

    func presentViewController(var state: HasNavigationState, targetViewController: String) -> HasNavigationState {
        state.navigationState.transitionToViewController = targetViewController
        state.navigationState.presentationType = .Custom(.Modal)

        return state
    }

    func dismissViewController(var state: HasNavigationState, parentViewController: String) -> HasNavigationState {
        state.navigationState.presentationType = .Custom(.Dismiss)
        state.navigationState.transitionToViewController = parentViewController

        return state
    }

    func completeNavigationToViewController(var state: HasNavigationState, completedTransitionViewController: String) -> HasNavigationState {
        if (state.navigationState.transitionToViewController == completedTransitionViewController) {
            state.navigationState.currentViewController = completedTransitionViewController
            state.navigationState.transitionToViewController = nil
            state.navigationState.presentationType = nil

            // TODO: most likely should not live here
//            if let tabBarController = state.navigationState.currentViewController as? UITabBarController {
//                state.navigationState.currentViewController = tabBarController.selectedViewController
//            }
        }

        return state
    }

    func setNavigationState(var state: HasNavigationState, targetViewController: String) -> HasNavigationState {
        state.navigationState.currentViewController = targetViewController

        return state
    }


}
