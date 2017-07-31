//
//  StackUsersDataSource.swift
//  TopStack
//
//  Created by Mike Gilroy on 31/07/2017.
//  Copyright © 2017 Mike Gilroy. All rights reserved.
//

import Foundation
import UIKit

protocol UsersDataSource: class, UITableViewDataSource, UITableViewDelegate {
	var apiService: UsersAPIService { get }
	var tableView: UITableView? { get set }
	func loadUsers(maxCount: Int, completion: (() -> Void)?)
}

class StackUsersDataSource: NSObject, UsersDataSource {
	
	// MARK: - Properties
	
	let apiService: UsersAPIService
	weak var tableView: UITableView?
	private(set) var users: [User] = []
	private(set) var isInErrorState = false
	
	
	// MARK: - Initialisation
	
	init(apiService: UsersAPIService, tableView: UITableView) {
		self.apiService = apiService
		self.tableView = tableView
		super.init()
		
		// Configure tableview delegate, datasource & estimated cell height
		self.tableView?.delegate = self
		self.tableView?.dataSource = self
		self.tableView?.estimatedRowHeight = 100
	}
	
	
	// MARK: - Load Users
	
	func loadUsers(maxCount: Int = 20, completion: (() -> Void)? = nil) {
		apiService.fetchUsers(maxCount: maxCount) { [weak self] (users, error) in
			guard error == nil else {
				self?.isInErrorState = true
				self?.reloadTableView()
				completion?()
				return
			}
			
			self?.isInErrorState = false
			self?.users = users ?? []
			self?.reloadTableView()
			completion?()
		}
	}
	
	private func reloadTableView() {
		DispatchQueue.main.async {
			self.tableView?.reloadData()
		}
	}
}


// MARK: - UITableViewDataSource
extension StackUsersDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return isInErrorState ? 1 : users.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if isInErrorState {
			return tableView.dequeueReusableCell(withIdentifier: "error_cell")!
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "user_cell", for: indexPath) as! UserTableViewCell
			let user = users[indexPath.row]
			cell.configure(with: user)
			return cell
		}
	}
}

// MARK: - UITableViewDelegate
extension StackUsersDataSource {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
}
