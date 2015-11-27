//
//  NavigationReducer.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit

struct NavigationReducer {
  
    func navigateToViewController(var state: NavigationStateProtocol, targetViewController: UIViewController) -> NavigationStateProtocol {
        state.navigationState.transitionToViewController = targetViewController

        return state
    }
    
    func presentViewController(var state: NavigationStateProtocol, targetViewController: UIViewController) -> NavigationStateProtocol {
        state.navigationState.transitionToViewController = targetViewController
        state.navigationState.presentationType = .Custom(.Modal)
        
        return state
    }
    
    func dismissViewController(var state: NavigationStateProtocol, parentViewController: UIViewController) -> NavigationStateProtocol {
        state.navigationState.presentationType = .Custom(.Dismiss)
        state.navigationState.transitionToViewController = parentViewController
        
        return state
    }
    
    func completeNavigationToViewController(var state: NavigationStateProtocol, completedTransitionViewController: UIViewController) -> NavigationStateProtocol {
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
    
    func setNavigationState(var state: NavigationStateProtocol, targetViewController: UIViewController) -> NavigationStateProtocol {
        state.navigationState.currentViewController = targetViewController
        
        return state
    }

  
}