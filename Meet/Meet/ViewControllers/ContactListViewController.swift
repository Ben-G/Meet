//
//  ContactListViewController.swift
//  Meet
//
//  Created by Benjamin Encz on 11/11/15.
//  Copyright © 2015 DigiTales. All rights reserved.
//

import UIKit
import ListKit

class ContactTableViewCell: UITableViewCell, ListKitCellProtocol {
    var model: Contact? {
        didSet {
            self.textLabel!.text = model?.emailAddress
        }
    }
}

class ContactListViewController: UIViewController, StoreSubscriber {
  
    @IBOutlet var tableView: UITableView!
    var store = mainStore
    var dataSource = ArrayDataSource(array: [], cellType: ContactTableViewCell.self)

    var contacts: [Contact]? {
        didSet {
            if let contacts = contacts {
                dataSource.array = contacts
                tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.dataSource = dataSource
        store.subscribe(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        store.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        contacts = state.dataState.contacts
    }

}
