//
//  UsersListViewController.swift
//  TopStack
//
//  Created by Mike Gilroy on 31/07/2017.
//  Copyright © 2017 Mike Gilroy. All rights reserved.
//

import UIKit

class UsersListViewController: UIViewController {

	// MARK: - Properties
	
	var usersDataSource: StackUsersDataSource?
	
	
	// MARK: - Outlets
	
	@IBOutlet weak var tableView: UITableView?
	@IBOutlet weak var reloadButton: UIBarButtonItem?
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView?
	
	
	// MARK: - Actions
	
	@IBAction func reloadTapped(_ sender: Any) {
		reloadButton?.isEnabled = false
		loadUsers()
	}
	
	
	// MARK: - VC Life Cycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView?.tableFooterView = UIView(frame: .zero)
		usersDataSource = StackUsersDataSource(apiService: StackUsersAPI(),
		                                       tableView: self.tableView ?? UITableView())
		loadUsers()
    }
	
	
	// MARK: - Load Users
	
	func loadUsers(completion: (() -> Void)? = nil) {
		activityIndicator?.startAnimating()
		tableView?.isHidden = true
		
		usersDataSource?.loadUsers { [weak self] in
			self?.tableView?.isHidden = false
			self?.activityIndicator?.stopAnimating()
			self?.reloadButton?.isEnabled = true
			completion?()
		}
	}
}
