//
//  AuthResponseModel.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/21/23.
//



import Foundation

struct AuthResponseModel: Decodable {
	var jwt: String
	var user: User
}

struct User: Codable {
	var id: Int
	var username: String
	var email: String
}
