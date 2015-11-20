//
//  MainReducer.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import Foundation

struct MainReducer: Reducer {
    
    var navigationReducer = NavigationReducer()
    var dataMutationReducer = DataMutationReducer()
    
    func handleAction(state: AppState, action: Action) -> AppState {
        switch action {
        case .SetNavigationState(let viewController):
            return navigationReducer.setNavigationState(state, targetViewController: viewController)
        case .NavigateTo(let viewController):
            return navigationReducer.navigateToViewController(state, targetViewController: viewController)
        case .CompleteNavigationTo(let viewController):
            return navigationReducer.completeNavigationToViewController(state, completedTransitionViewController: viewController)
        case .PresentViewController(let viewController):
            return navigationReducer.presentViewController(state, targetViewController: viewController)
        case .DismissViewController(let viewController):
            return navigationReducer.dismissViewController(state, parentViewController: viewController)
        case .CreateContactFromEmail(let email):
            return dataMutationReducer.createContact(state, email: email)
        }
    }
    
}