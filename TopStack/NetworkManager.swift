//
//  NetworkManager.swift
//  TopStack
//
//  Created by Mike Gilroy on 31/07/2017.
//  Copyright © 2017 Mike Gilroy. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

protocol HTTPHandler {
	func getData(url: URL?, completion: @escaping (Any?, Error?) -> Void)
}

protocol ImageLoader {
	func getImage(url: URL?, completion: @escaping (UIImage?) -> Void)
}

struct NetworkManager: HTTPHandler, ImageLoader {
	
	/// GET data from given URL. No cache is used by default.
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
	
	/// GET image data from given URL and return as optional UIImage. A cache is used by default.
	func getImage(url: URL?, completion: @escaping (UIImage?) -> Void) {
		
		guard let url = url else {
			completion(nil)
			return
		}
		let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 20.0)
		
		Alamofire.request(urlRequest).responseData(completionHandler: { (response) in
			if let data = response.data {
				completion(UIImage(data: data))
			} else {
				completion(nil)
			}
		})
	}
}
