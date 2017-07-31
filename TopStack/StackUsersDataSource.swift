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
	
	init(apiService: UsersAPIService, tableView: UITableView) {
		self.apiService = apiService
		self.tableView = tableView
		super.init()
	}
	
	
	func loadUsers(maxCount: Int, completion: (() -> Void)? = nil) {
		
	}
}


// MARK: - UITableViewDataSource
extension StackUsersDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return users.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
}
