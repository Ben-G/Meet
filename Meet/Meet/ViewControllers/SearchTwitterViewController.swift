//
//  SearchTwitterViewController.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import ListKit
import SwiftFlowReactiveCocoaExtensions
import SwiftFlowRouter
import SwiftFlow

class SearchTwitterViewController: UIViewController, StoreSubscriber {

    @IBOutlet var tableView: UITableView!
    
    var store = mainStore
    var dataSource = ArrayDataSource(cellType: TwitterUserTableViewCell.self, nib: UINib(nibName: "TwitterUserTableViewCell", bundle: nil))

    var navigationActionCreator = NavigationActionCreator()
    var twitterAPIActionCreator = TwitterAPIActionCreator()
    
    var users: [TwitterUser]? {
        didSet {
            if let users = users {
                dataSource.array = users
                tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        store.subscribe(self)
        tableView.dataSource = dataSource
    }
    
    func newState(state: AppState) {
        users = state.twitterAPIState.userSearchResults
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        store.dispatch( TwitterAPIAction.SetUserSearchResults([]) )
        store.dispatch( self.navigationActionCreator.dismissViewController(presentingViewController: self.presentingViewController!) )
    }
    
}

extension SearchTwitterViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        store.dispatch( self.twitterAPIActionCreator.searchUsers(searchText) )
    }
    
}