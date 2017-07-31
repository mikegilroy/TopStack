//
//  UsersListViewController.swift
//  TopStack
//
//  Created by Mike Gilroy on 31/07/2017.
//  Copyright © 2017 Mike Gilroy. All rights reserved.
//

import UIKit

class UsersListViewController: UIViewController {

	// MARK: - Outlets
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var reloadButton: UIBarButtonItem!
	@IBOutlet var usersDataSource: StackUsersDataSource!
	
	
	// MARK: - Actions
	
	@IBAction func reloadTapped(_ sender: Any) {
		loadUsers()
	}
	
	
	// MARK: - VC Life Cycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		usersDataSource = StackUsersDataSource(apiService: StackUsersAPI(), tableView: self.tableView)
    }
	
	
	// MARK: - Load Users
	
	func loadUsers() {
		usersDataSource.loadUsers(maxCount: 20)
	}
}
