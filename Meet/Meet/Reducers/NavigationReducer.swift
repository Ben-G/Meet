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

public struct NavigationReducer<StateType: NavigationStateProtocol>: Reducer {
  
    public init() {}
    
    public func handleAction(state: StateType, action: ActionProtocol) -> StateType {
        if let action = action as? NavigationActions {
            switch action {
            case .SetNavigationState(let viewController):
                return self.setNavigationState(state, targetViewController: viewController)
            case .NavigateTo(let viewController):
                return self.navigateToViewController(state, targetViewController: viewController)
            case .CompleteNavigationTo(let viewController):
                return self.completeNavigationToViewController(state, completedTransitionViewController: viewController)
            case .PresentViewController(let viewController):
                return self.presentViewController(state, targetViewController: viewController)
            case .DismissViewController(let viewController):
                return self.dismissViewController(state, parentViewController: viewController)
            }
        }
        
        return state
    }
    
    func navigateToViewController(var state: StateType, targetViewController: UIViewController) -> StateType {
        state.navigationState.transitionToViewController = targetViewController

        return state
    }
    
    func presentViewController(var state: StateType, targetViewController: UIViewController) -> StateType {
        state.navigationState.transitionToViewController = targetViewController
        state.navigationState.presentationType = .Custom(.Modal)
        
        return state
    }
    
    func dismissViewController(var state: StateType, parentViewController: UIViewController) -> StateType {
        state.navigationState.presentationType = .Custom(.Dismiss)
        state.navigationState.transitionToViewController = parentViewController
        
        return state
    }
    
    func completeNavigationToViewController(var state: StateType, completedTransitionViewController: UIViewController) -> StateType {
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
    
    func setNavigationState(var state: StateType, targetViewController: UIViewController) -> StateType {
        state.navigationState.currentViewController = targetViewController
        
        return state
    }

  
}