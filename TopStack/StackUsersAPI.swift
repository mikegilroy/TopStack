//
//  StackUsersAPI.swift
//  TopStack
//
//  Created by Mike Gilroy on 31/07/2017.
//  Copyright © 2017 Mike Gilroy. All rights reserved.
//

import Foundation

protocol UsersAPIService {
	var requestHandler: HTTPHandler { get }
	var parser: DataParser { get }
	func fetchUsers(maxCount: Int, completion: @escaping ([User]?, Error?) -> Void)
}

class StackUsersAPI: UsersAPIService {
	
	private let baseURL = "http://api.stackexchange.com/2.2/users?order=desc&sort=reputation&site=stackoverflow"
	
	let requestHandler: HTTPHandler
	let parser: DataParser
	
	convenience init() {
		self.init(requestHandler: NetworkManager(), parser: JSONParser())
	}
	
	init(requestHandler: HTTPHandler, parser: DataParser) {
		self.requestHandler = requestHandler
		self.parser = parser
	}
	
	
	func fetchUsers(maxCount: Int, completion: @escaping ([User]?, Error?) -> Void) {
		
		guard let url = URL(string: baseURL + "&pagesize=\(maxCount)") else {
			completion(nil, nil)
			return
		}
		
		requestHandler.getData(url: url) { [unowned self] (data, error) in
			guard error == nil,
				let data = data else {
				completion(nil, error)
				return
			}
			
			if let json = self.parser.dictionary(from: data),
				let userResult = StackUsersResult(json: json) {
				completion(userResult.items, nil)
			} else {
				completion(nil, nil)
			}
		}
	}
	
}
