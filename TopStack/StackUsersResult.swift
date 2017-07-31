//
//  StackUsersResult.swift
//  TopStack
//
//  Created by Mike Gilroy on 31/07/2017.
//  Copyright © 2017 Mike Gilroy. All rights reserved.
//

import Foundation

protocol UsersResult: JSONInitialisable {
	var items: [User] { get}
}

struct StackUsersResult: UsersResult {

	// MARK: - Keys
	
	private let kItems = "items"
	
	
	// MARK: - Properties
	
	let items: [User]
	
	
	// MARK: Initialisation
	
	init?(json: [String: Any]) {
		guard let items = json[kItems] as? [[String: Any]] else {
			return nil
		}
		self.items = items.flatMap { StackUser(json: $0) }
	}
}
