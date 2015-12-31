//
//  SearchTwitterViewController.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import ListKit
import SwiftFlowRouter
import SwiftFlow

class SearchTwitterViewController: UIViewController, StoreSubscriber, Routable {

    static let identifier = "SearchTwitterViewController"

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!

    var errorView: NetworkErrorView?
    var store = mainStore
    var dataSource = ArrayDataSource(cellType: TwitterUserTableViewCell.self,
        nib: UINib(nibName: "TwitterUserTableViewCell", bundle: nil))

    var twitterAPIActionCreator = TwitterAPIActionCreator()
    var searchText: String? {
        didSet {
            searchBar.text = searchText
        }
    }

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
                if errorView == nil {
                    guard let loadedView = NSBundle.mainBundle().loadNibNamed("NetworkErrorView",
                        owner: self, options: nil)[0] as? NetworkErrorView else { return }

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

        searchText = state.twitterAPIState.userSearchText
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        store.dispatch( SetUserSearchResult(.Success([])) )
//        store.dispatch(
//            NavigationAction.DismissViewController(presentingViewController:
//                self.presentingViewController!)
//        )
    }

    func retrySearch() {
        store.dispatch( self.twitterAPIActionCreator.searchUsers(searchText!) )
    }

}

extension SearchTwitterViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let twitterUser = dataSource.array[indexPath.row]

        store.dispatch( CreateContactWithTwitterUser(twitterUser) )
//        store.dispatch(
//            NavigationAction.DismissViewController(presentingViewController:
//                self.presentingViewController!)
//        )
    }

}

extension SearchTwitterViewController: UISearchBarDelegate {

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        store.dispatch( SetUserSearchText(searchText) )
        store.dispatch( self.twitterAPIActionCreator.searchUsers(searchText) )
    }

}
