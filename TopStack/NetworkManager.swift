//
//  NetworkManager.swift
//  TopStack
//
//  Created by Mike Gilroy on 31/07/2017.
//  Copyright © 2017 Mike Gilroy. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkHandler {
	func getData(url: URL?, completion: @escaping (Any?, Error?) -> Void)
}

struct NetworkManager: NetworkHandler {
	
	func getData(url: URL?, completion: @escaping (Any?, Error?) -> Void) {
		
		guard let url = url else {
			completion(nil, nil)
			return
		}
		let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 20.0)
		
		Alamofire.request(urlRequest).responseJSON { (response) in
			completion(response.data, response.error)
		}
	}
}
