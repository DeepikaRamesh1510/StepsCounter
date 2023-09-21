//
//  StepCounterEndPoint.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/21/23.
//



import Foundation
import KeychainAccess

protocol Endpoint {
	var scheme: String { get }
	var host: String { get }
	var path: String { get }
	var method: RequestMethod { get }
	var header: [String: String]? { get }
	var body: [String: Any]? { get }
	var isAuthorizationRequired: Bool { get }
}

extension Endpoint {
	var scheme: String {
		return "https"
	}
	
	var host: String {
		return "testapi.mindware.us"
	}
}

enum StepCounterEndPoint {
	case login
	case uploadSteps(StepsModel)
}

extension StepCounterEndPoint: Endpoint {
	
	var path: String {
		switch self {
			case .login:
				return "/auth/local"
			case .uploadSteps:
				return "/steps"
		}
	}
	
	var method: RequestMethod {
		switch self {
			case .uploadSteps: return .post
			case .login: return .post
		}
	}
	
	var header: [String: String]? {
		
		var header: [String: String] = [:]
		
		if self.isAuthorizationRequired {
			
			guard let accessToken = keychain["JWToken"] else {
				NotificationCenter.default.post(name: Notification.Name.unauthorized, object: nil)
				return nil
			}
			header["Authorization"] = "bearer \(accessToken)"
		}
		if self.method == .post {
			header["Content-Type"] = "application/json; charset=utf-8"
			header["Accept"] = "application/json"
		}
		return header
	}
	
	var isAuthorizationRequired: Bool {
		switch self {
			case .login:
				return false
			case .uploadSteps:
				return true
		}
	}
	
	var body: [String: Any]? {
		switch self {
			case .login:
				return nil
			case .uploadSteps(let stepsUploadModel):
				return try? stepsUploadModel.asDictionary()
		}
	}
}
