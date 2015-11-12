//
//  ActionCreators.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit

struct NavigationActionCreator {
    
    func setCurrentViewController(viewController: UIViewController) -> ActionCreator {
        return { _ in
            return .SetNavigationState(viewController)
        }
    }
    
    func navigateToViewController(viewController: UIViewController) -> ActionCreator {
        return { _ in
            return .NavigateTo(viewController)
        }
    }
    
    func naviateToViewControllerCompleted(viewController: UIViewController) -> ActionCreator {
        return { _ in
            return .CompleteNavigationTo(viewController)
        }
    }
    
}