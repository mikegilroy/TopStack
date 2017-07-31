//
//  StackUser.swift
//  TopStack
//
//  Created by Mike Gilroy on 31/07/2017.
//  Copyright © 2017 Mike Gilroy. All rights reserved.
//

import Foundation

protocol User: JSONInitialisable {
	var displayName: String { get }
	var reputation: Int { get }
	var profileImageURL: String { get }
}

class StackUser: User {
	
	// MARK: - Keys
	
	private let kDisplayName = "display_name"
	private let kReputation = "reputation"
	private let kProfileImage = "profile_image"
	
	
	// MARK: - Properties
	
	let displayName: String
	let reputation: Int
	let profileImageURL: String
	
	
	// MARK: - Initialisation
	
	required init?(json: [String : Any]) {
		guard let displayName = json[kDisplayName] as? String,
			let reputation = json[kReputation] as? Int,
			let profileImageURL = json[kProfileImage] as? String else {
				return nil
		}
		
		self.displayName = displayName
		self.reputation = reputation
		self.profileImageURL = profileImageURL
	}
}
