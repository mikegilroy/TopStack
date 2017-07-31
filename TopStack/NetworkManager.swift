//
//  NetworkManager.swift
//  TopStack
//
//  Created by Mike Gilroy on 31/07/2017.
//  Copyright © 2017 Mike Gilroy. All rights reserved.
//

import Foundation

protocol NetworkHandler {
	func getData(url: URL?, completion: @escaping (Data?, Error?) -> Void)
}

struct NetworkManager: NetworkHandler {
	
	func getData(url: URL?, completion: @escaping (Data?, Error?) -> Void) {
		let config = URLSessionConfiguration.default
		let session = URLSession(configuration: config)
		
		guard let url = url else {
			completion(nil, nil)
			return
		}
		
		session.dataTask(with: url) { (data, response, error) in
			completion(data, error)
			}.resume()
	}
}
