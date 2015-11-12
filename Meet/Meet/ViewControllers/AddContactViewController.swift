//
//  AddContactViewController.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {
  
    @IBAction func addTwitterButtonTapped(sender: AnyObject) {
        // TODO: Should not be instantiated here
        let searchTwitterViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SearchTwitterViewController")
        
        mainStore.dispatch { NavigationActionCreator().navigateToViewController(searchTwitterViewController) }
    }
}
