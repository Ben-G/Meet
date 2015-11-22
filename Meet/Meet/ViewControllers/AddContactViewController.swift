//
//  AddContactViewController.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit

struct PendingAction {
    let action: (AppState) -> Bool
    
    func resolve(appState: AppState) -> Bool {
        let resolved = action(appState)
        
        return resolved
    }
}

class AddContactViewController: UIViewController, StoreSubscriber {
  
    var store = mainStore
    var navigationActionCreator = NavigationActionCreator()
    var dataMutationActionCreator = DataMutationActionCreator()
    var twitterAPIActionCreator = TwitterAPIActionCreator()
    
    var pendingActions: [PendingAction] = []
    
    override func viewWillAppear(animated: Bool) {
        store.subscribe(self)
    }
    
    func newState(state: AppState) {
        for var i = 0; i < pendingActions.count; i++ {
            let pendingAction = pendingActions[i]
            let resolved = pendingAction.resolve(state)
            
            if resolved == true {
                pendingActions.removeAtIndex(i)
            }
        }
    }
    
    
    @IBAction func emailIntroButtonTapped(sender: AnyObject) {
        let emailIntroViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EmailIntroViewController")
        
//        store.dispatch { self.navigationActionCreator.navigateToViewController(emailIntroViewController) }
        store.dispatch { self.dataMutationActionCreator.createNewContact("Benjamin.Encz@gmail.com") }
    }
    
    @IBAction func addTwitterButtonTapped(sender: AnyObject) {
        // TODO: Should not be instantiated here
        
        let navigateToTwitterViewController = PendingAction { state in
            if state.twitterAPIState.swifter != nil {
                let searchTwitterViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SearchTwitterViewController")
                
                self.store.dispatch {
                    self.navigationActionCreator.navigateToViewController(searchTwitterViewController)
                }
                return true
            } else {
                return false
            }
        }
        
        pendingActions.append(navigateToTwitterViewController)
        
        store.dispatch { self.twitterAPIActionCreator.authenticateUser() }
    }
}