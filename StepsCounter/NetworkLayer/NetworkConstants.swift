//
//  NetworkConstants.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/21/23.
//



import Foundation

enum RequestMethod: String {
	case get = "GET"
	case post = "POST"
	case put = "PUT"
}

enum NetworkError: Error {
	case decode
	case unauthorized
	case custom(String)
	
	var description: String {
		switch self {
			case .decode:
				return "Decode error"
			case .unauthorized:
				return "Session expired"
			case .custom(let msg):
				return msg
		}
	}
}

extension Encodable {
	func asDictionary() throws -> [String: Any] {
		let data = try JSONEncoder().encode(self)
		guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
			throw NSError()
		}
		return dictionary
	}
}
