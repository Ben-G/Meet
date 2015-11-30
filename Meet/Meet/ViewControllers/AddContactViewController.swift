//
//  AddContactViewController.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import SwiftFlowReactiveCocoaExtensions
import SwiftFlow
import SwiftFlowRouter

class AddContactViewController: UIViewController, StoreSubscriber {
  
    var store = mainStore
    var twitterAPIActionCreator = TwitterAPIActionCreator()
    
    override func viewWillAppear(animated: Bool) {
        store.subscribe(self)
    }
    
    func newState(maybeState: StateType) {
        guard let state = maybeState as? AppState else { return }
    }
    
    @IBAction func emailIntroButtonTapped(sender: AnyObject) {
        let emailIntroViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EmailIntroViewController")
        
//        store.dispatch { self.navigationActionCreator.navigateToViewController(emailIntroViewController) }
        store.dispatch(DataMutationAction.CreateContactFromEmail("Benjamin.Encz@gmail.com"))
    }
    
    @IBAction func addTwitterButtonTapped(sender: AnyObject) {
        // TODO: Should not be instantiated here
        store.dispatch ( self.twitterAPIActionCreator.authenticateUser() ) { state in
            if let state = state as? HasTwitterAPIState {
                if (state.twitterAPIState.swifter != nil) {
                    let searchTwitterViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SearchTwitterViewController")
                    self.store.dispatch (NavigationAction.NavigateTo(searchTwitterViewController))
                }
            }
        }
    }
}