//
//  ActionCreators.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwiftFlowReactiveCocoaExtensions

struct NavigationActionCreator {
    
    typealias ActionCreator = (state: NavigationState, store: NavigationStore) -> NavigationActions?
    
    func setCurrentViewController(viewController: UIViewController) -> ActionCreator {
        return { _ in
            return .SetNavigationState(viewController)
        }
    }
    
    func presentViewController(viewController: UIViewController) -> ActionCreator {
        return { _ in
            return .PresentViewController(viewController)
        }
    }
    
    func dismissViewController(presentingViewController presentingViewController: UIViewController) -> ActionCreator {
        return { _ in
            return .DismissViewController(presentingViewController)
        }
    }
    
    func navigateToViewController(viewController: UIViewController) -> ActionCreator {
        return { _ in
            return .NavigateTo(viewController)
        }
    }
    
    func navigateToViewControllerCompleted(viewController: UIViewController) -> ActionCreator {
        return { _ in
            return .CompleteNavigationTo(viewController)
        }
    }
    
}