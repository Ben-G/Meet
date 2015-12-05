//
//  ContactListViewController.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import ListKit
import ReactiveCocoa
import SwiftFlow
import SwiftFlowRouter
import SwiftFlowReactiveCocoaExtensions

class ContactTableViewCell: UITableViewCell, ListKitCellProtocol {
    var model: Contact? {
        didSet {
            self.textLabel!.text = model?.displayName
        }
    }
}

class ContactListViewController: UIViewController, StoreSubscriber {

    static let identifier = "ContactListViewController"

    @IBOutlet var tableView: UITableView!

    var store = mainStore

    var dataSource = ArrayDataSource(array: [], cellType: ContactTableViewCell.self)

    var contacts: [Contact]? {
        didSet {
            if let contacts = contacts {
                dataSource.array = contacts
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        tableView.dataSource = self
        store.subscribe(self)
        tableView.reloadData()
    }

    override func viewWillDisappear(animated: Bool) {
        store.unsubscribe(self)
    }

    func newState(state: HasDataState) {
        contacts = state.dataState.contacts
    }

}

extension ContactListViewController: UITableViewDataSource {


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {

        return self.dataSource.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.tableView(tableView, numberOfRowsInSection: section)
    }

    func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {

        let contactID = dataSource.array[indexPath.row].identifier

        // TODO: Consider implementing this as a pending action, or alternatively as an extension
        // on UITableView using Dwift: https://github.com/jflinter/Dwifft or 
        //https://github.com/brutella/simplediff-swift
        store.dispatch( DeleteContact(contactID) ) { appState in
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }

}

extension ContactListViewController: Routable {

}
