//
//  StackUsersAPI.swift
//  TopStack
//
//  Created by Mike Gilroy on 31/07/2017.
//  Copyright © 2017 Mike Gilroy. All rights reserved.
//

import Foundation

protocol UsersAPIService {
	var networkHandler: NetworkHandler { get }
	var parser: DataParser { get }
	func fetchUsers(maxCount: Int, completion: @escaping ([User]?, Error?) -> Void)
}

class StackUsersAPI: UsersAPIService {
	
	private let baseURL = "http://api.stackexchange.com/2.2/users?pagesize=20&order=desc&sort=reputation&site=stackoverflow"
	
	let networkHandler: NetworkHandler
	let parser: DataParser
	
	convenience init() {
		self.init(networkHandler: NetworkManager(), parser: JSONParser())
	}
	
	init(networkHandler: NetworkHandler, parser: DataParser) {
		self.networkHandler = networkHandler
		self.parser = parser
	}
	
	
	func fetchUsers(maxCount: Int, completion: @escaping ([User]?, Error?) -> Void) {
		
		guard let url = URL(string: baseURL) else {
			completion(nil, nil)
			return
		}
		
		networkHandler.getData(url: url) { [unowned self] (data, error) in
			guard error == nil,
				let data = data else {
				completion(nil, error)
				return
			}
			
			
			if let dictionary = self.parser.dictionary(from: data) {
				// Instantiate users
				completion([], nil)
			} else {
				completion(nil, nil)
			}
		}
		
	}
	
}
