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
	
	let apiService: UsersAPIService
	weak var tableView: UITableView?
	
	var users: [User] = []
	var isInErrorState = false
	
	
	// MARK: - Initialisation
	
	init(apiService: UsersAPIService, tableView: UITableView) {
		self.apiService = apiService
		self.tableView = tableView
		super.init()
	}
	
	
	// MARK: - Load Users
	
	func loadUsers(maxCount: Int, completion: (() -> Void)? = nil) {
		apiService.fetchUsers(maxCount: maxCount) { [unowned self] (users, error) in
			guard error == nil else {
				self.isInErrorState = true
				self.reloadTableView()
				completion?()
				return
			}
			
			self.users = users ?? []
			self.reloadTableView()
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
			let cell = tableView.dequeueReusableCell(withIdentifier: "user_cell", for: indexPath)
			let user = users[indexPath.row]
			// Config cell with user 
			return cell
		}
	}
}
