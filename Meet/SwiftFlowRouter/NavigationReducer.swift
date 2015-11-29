//
//  NavigationReducer.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwiftFlow
import SwiftFlowReactiveCocoaExtensions

public struct NavigationReducer: Reducer {
    
    public init() {}
    
    public func handleAction(state: HasNavigationState, action: NavigationAction) -> HasNavigationState {
        switch action {
        case .SetNavigationState(let viewController):
            return setNavigationState(state, targetViewController: viewController)
        case .NavigateTo(let viewController):
            return navigateToViewController(state, targetViewController: viewController)
        case .CompleteNavigationTo(let viewController):
            return completeNavigationToViewController(state, completedTransitionViewController: viewController)
        case .PresentViewController(let viewController):
            return presentViewController(state, targetViewController: viewController)
        case .DismissViewController(let viewController):
            return dismissViewController(state, parentViewController: viewController)
        }
    }

    func navigateToViewController(var state: HasNavigationState, targetViewController: UIViewController) -> HasNavigationState {
        state.navigationState.transitionToViewController = targetViewController

        return state
    }
    
    func presentViewController(var state: HasNavigationState, targetViewController: UIViewController) -> HasNavigationState {
        state.navigationState.transitionToViewController = targetViewController
        state.navigationState.presentationType = .Custom(.Modal)
        
        return state
    }
    
    func dismissViewController(var state: HasNavigationState, parentViewController: UIViewController) -> HasNavigationState {
        state.navigationState.presentationType = .Custom(.Dismiss)
        state.navigationState.transitionToViewController = parentViewController
        
        return state
    }
    
    func completeNavigationToViewController(var state: HasNavigationState, completedTransitionViewController: UIViewController) -> HasNavigationState {
        if (state.navigationState.transitionToViewController == completedTransitionViewController) {
            state.navigationState.currentViewController = completedTransitionViewController
            state.navigationState.transitionToViewController = nil
            state.navigationState.presentationType = nil
            
            // TODO: most likely should not live here
            if let tabBarController = state.navigationState.currentViewController as? UITabBarController {
                state.navigationState.currentViewController = tabBarController.selectedViewController
            }
        }
        
        return state
    }
    
    func setNavigationState(var state: HasNavigationState, targetViewController: UIViewController) -> HasNavigationState {
        state.navigationState.currentViewController = targetViewController
        
        return state
    }

  
}