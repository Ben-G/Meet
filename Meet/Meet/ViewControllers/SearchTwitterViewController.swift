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
    
    var errorView: NetworkErrorView?
    var store = mainStore
    var dataSource = ArrayDataSource(cellType: TwitterUserTableViewCell.self, nib: UINib(nibName: "TwitterUserTableViewCell", bundle: nil))

    var twitterAPIActionCreator = TwitterAPIActionCreator()
    
    var searchText: String?
    
    var users: [TwitterUser]? {
        didSet {
            if let users = users {
                dataSource.array = users
                tableView.reloadData()
            }
        }
    }
    
    var error: TwitterAPIError? {
        didSet {
            if let error = error {
                if (errorView == nil) {
                    let loadedView = NSBundle.mainBundle().loadNibNamed("NetworkErrorView", owner: self, options: nil)[0] as! NetworkErrorView
                    errorView = loadedView
                    errorView?.retryFunction = { self.retrySearch($0) }
                    errorView!.center = view.center
                    view.addSubview(errorView!)
                }
            } else {
                if let errorView = errorView {
                    self.errorView?.removeFromSuperview()
                    self.errorView = nil
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        store.subscribe(self)
        tableView.dataSource = dataSource
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
    

    func retrySearch() {
        store.dispatch( self.twitterAPIActionCreator.searchUsers(searchText!) )
    }
    
}

extension SearchTwitterViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let twitterUser = dataSource.array[indexPath.row]
        
        store.dispatch( DataMutationAction.CreateContactWithTwitterUser(twitterUser) )
        store.dispatch( NavigationAction.DismissViewController(presentingViewController: self.presentingViewController!) )
    }
    
}

extension SearchTwitterViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        store.dispatch( self.twitterAPIActionCreator.searchUsers(searchText) )
    }
    
}