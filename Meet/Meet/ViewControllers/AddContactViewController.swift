//
//  AddContactViewController.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {
  
    var store = mainStore
    var navigationActionCreator = NavigationActionCreator()
    
    @IBAction func emailIntroButtonTapped(sender: AnyObject) {
        let emailIntroViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EmailIntroViewController")
        
        store.dispatch { self.navigationActionCreator.navigateToViewController(emailIntroViewController) }
    }
    
    @IBAction func addTwitterButtonTapped(sender: AnyObject) {
        // TODO: Should not be instantiated here
        let searchTwitterViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SearchTwitterViewController")
        
        store.dispatch { self.navigationActionCreator.navigateToViewController(searchTwitterViewController) }
    }
}
