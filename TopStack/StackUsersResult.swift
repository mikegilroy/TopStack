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

	private let kItems = "items"
	
	let items: [User]
	
	
	// MARK: Initialisation
	
	init?(json: [String: Any]) {
		guard let items = json[kItems] as? [[String: Any]] else {
			return nil
		}
		self.items = items.flatMap { StackUser(json: $0) }
	}
}
