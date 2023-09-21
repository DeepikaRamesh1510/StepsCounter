//
//  AppConstants.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/21/23.
//



import Foundation

import UserDefaultsService

enum StepCounterUDKeys: String, UserDefaultsKeyProtocol {
	var key: String { self.rawValue }
	case todayStepCountLastRetreivedTime
}


enum StepCounterError: Error {
	case healthkitUnAuthorized
	case unableToFetchHealthData
}

struct DateHelper {
	
	static var calendar: Calendar { return Calendar.current }
	
	static var currentDate: Date { return Date() }
	
	static var startOfToday: Date {
		return calendar.startOfDay(for: Date())
	}
	
	static var startOfWeek: Date {
		
		return calendar.date(from: calendar.dateComponents(
			[.yearForWeekOfYear, .weekOfYear],
			from: startOfToday)
		) ?? Date()
	}
	
	static var endOfWeek: Date {
		return calendar.date(byAdding: .day, value: 7, to: startOfWeek) ?? Date()
	}
}
