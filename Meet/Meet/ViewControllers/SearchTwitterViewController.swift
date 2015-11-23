//
//  SearchTwitterViewController.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import ListKit

class SearchTwitterViewController: UIViewController, StoreSubscriber {

    var store = mainStore
    var navigationActionCreator = NavigationActionCreator()
    var twitterAPIActionCreator = TwitterAPIActionCreator()
    
    var users: [TwitterUser]? {
        didSet {
            print(users)
        }
    }
    
    func newState(state: AppState) {
        users = state.twitterAPIState.userSearchResults
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        store.dispatch { self.navigationActionCreator.dismissViewController(presentingViewController: self.presentingViewController!) }
    }
    
}

extension SearchTwitterViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        store.dispatch { self.twitterAPIActionCreator.searchUsers(searchText) }
    }
    
}