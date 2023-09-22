//
//  StepsUploadModel.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/21/23.
//



import Foundation

struct StepsUploadModel: Codable {
	var name: String
	var stepsDate: String
	var stepsDateTime: String
	var stepsCount: Int
	var stepsTotalByDay: Int
	
	enum CodingKeys: String, CodingKey {
		case name = "username"
		case stepsDate = "steps_date"
		case stepsDateTime = "steps_datetime"
		case stepsCount = "steps_count"
		case stepsTotalByDay = "steps_total_by_day"
	}
}

struct StepsResponseModel: Codable {
	var id: String
	var stepsDateTime: String
	var stepsCount: Int
	var stepsTotalByDay: Int
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case stepsDateTime = "steps_datetime"
		case stepsCount = "steps_count"
		case stepsTotalByDay = "steps_total_by_day"
	}
}
