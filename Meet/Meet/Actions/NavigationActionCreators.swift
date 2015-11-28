//
//  ActionCreators.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwiftFlowReactiveCocoaExtensions

public struct NavigationActionCreator {
    
    public init() {}
    
    public func setCurrentViewController(viewController: UIViewController) -> ActionCreator {
        return { _ in
            return NavigationAction.SetNavigationState(viewController)
        }
    }
    
    public func presentViewController(viewController: UIViewController) -> ActionCreator {
        return { _ in
            return NavigationAction.PresentViewController(viewController)
        }
    }
    
    public func dismissViewController(presentingViewController presentingViewController: UIViewController) -> ActionCreator {
        return { _ in
            return NavigationAction.DismissViewController(presentingViewController)
        }
    }
    
    public func navigateToViewController(viewController: UIViewController) -> ActionCreator {
        return { _ in
            return NavigationAction.NavigateTo(viewController)
        }
    }
    
    public func navigateToViewControllerCompleted(viewController: UIViewController) -> ActionCreator {
        return { _ in
            return NavigationAction.CompleteNavigationTo(viewController)
        }
    }
    
}