//
//  SearchTwitterViewController.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit

class SearchTwitterViewController: UIViewController {

    var store = mainStore
    var navigationActionCreator = NavigationActionCreator()
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        store.dispatch { self.navigationActionCreator.dismissViewController(presentingViewController: self.presentingViewController!) }
    }
    
}