//
//  AppConstants.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/21/23.
//



import Foundation
import KeychainAccess
import UserDefaultsService
import SwiftUICharts

struct AppConstant {
	static var bundleId: String { Bundle.main.bundleIdentifier ?? "StepsCounter" }
	static var legend: Legend = Legend(color: .blue, label: "StepCount", order: 1)
}

let keychain = Keychain(service: AppConstant.bundleId)

enum StepCounterUDKeys: String, UserDefaultsKeyProtocol {
	var key: String { self.rawValue }
	
	case todayStepCountLastRetreivedTime
	case appUser
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
	
	static var endOfToday: Date {
		var components = DateComponents()
		components.day = 1
		components.second = -1
		return Calendar.current.date(byAdding: components, to: startOfToday)!
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


extension Notification.Name {
	static var unauthorized = Notification.Name("unauthorized")
}
