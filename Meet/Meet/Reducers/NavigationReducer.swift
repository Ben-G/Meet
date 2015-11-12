//
//  NavigationReducer.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit

struct NavigationReducer {
  
    func navigateToViewController(var state: AppState, targetViewController: UIViewController) -> AppState {
        state.navigationState.transitionToViewController = targetViewController

        return state
    }
    
    func completeNavigationToViewController(var state: AppState, completedTransitionViewController: UIViewController) -> AppState {
        if (state.navigationState.transitionToViewController == completedTransitionViewController) {
            state.navigationState.currentViewController = completedTransitionViewController
            state.navigationState.transitionToViewController = nil
        }
        
        return state
    }
    
    func setNavigationState(var state: AppState, targetViewController: UIViewController) -> AppState {
        state.navigationState.currentViewController = targetViewController
        
        return state
    }

  
}