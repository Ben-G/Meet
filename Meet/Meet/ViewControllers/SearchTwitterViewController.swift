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
    var errorDataSource: ErrorDataSource!

    var twitterAPIActionCreator = TwitterAPIActionCreator()
    
    var users: [TwitterUser]? {
        didSet {
            if let users = users {
                tableView.dataSource = dataSource
                dataSource.array = users
                tableView.reloadData()
            }
        }
    }
    
    var error: TwitterSearchError? {
        didSet {
            if let error = error {
                tableView.dataSource = errorDataSource
                tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        store.subscribe(self)
        tableView.dataSource = dataSource
        errorDataSource = ErrorDataSource(tableView: tableView)
    }
    
    override func viewWillDisappear(animated: Bool) {
        errorDataSource = nil
    }
    
    func newState(state: AppState) {
        if let searchResults = state.twitterAPIState.userSearchResults {
            switch searchResults {
            case let .Success(users):
                self.users = users
                self.error = nil
            case let .Failure(error):
                self.error = error
                self.users = nil
            }
        }
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        store.dispatch( TwitterAPIAction.SetUserSearchResults(.Success([])) )
        store.dispatch( NavigationAction.DismissViewController(presentingViewController: self.presentingViewController!) )
    }
    
}

extension SearchTwitterViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        store.dispatch( self.twitterAPIActionCreator.searchUsers(searchText) )
    }
    
}

class ErrorDataSource: NSObject, UITableViewDataSource {
    
    init(tableView: UITableView) {
        let nib = UINib(nibName: "TwitterSearchErrorTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "TwitterSearchErrorCell")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TwitterSearchErrorCell", forIndexPath: indexPath)
        
        return cell
    }
    
}