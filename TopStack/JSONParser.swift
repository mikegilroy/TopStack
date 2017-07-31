//
//  JSONParser.swift
//  TopStack
//
//  Created by Mike Gilroy on 31/07/2017.
//  Copyright © 2017 Mike Gilroy. All rights reserved.
//

import Foundation


protocol JSONInitialisable {
	init?(json: [String: Any])
}

protocol DataParser {
	func dictionary(from data: Any?) -> [String: Any]?
}

struct JSONParser: DataParser {
	
	/// Returns an dictionary from data given in JSON format. If JSON serlialization fails then nil will be returned.
	func dictionary(from data: Any?) -> [String: Any]? {
		guard let data = data as? Data else {
			return nil
		}
		
		do {
			return (try JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any]
		} catch {
			print("Error serializing json")
			return nil
		}
	}
}

