	//
	//  HistoryViewModel.swift
	//  StepsCounter
	//
	//  Created by Deepika Ramesh on 9/21/23.
	//



import Foundation
import SwiftUICharts
import Combine

enum HistoryType {
	case seven
	case thirty
}

class HistoryViewModel: ObservableObject {
	
	
	@Published
	var last7DaysDataPoints: [DataPoint] = []
	
	@Published
	var last30DaysDataPoints: [DataPoint] = []
	
	var cancellable: Set<AnyCancellable> = []
	@Published
	var historyType: HistoryType = .seven
	var healthKitManager: HealthKitManager
	
	init(
		healthKitManager: HealthKitManager
	) {
		self.healthKitManager = healthKitManager
		setup()
	}
	
	func setup() {
		self.healthKitManager.$thisWeekSteps
			.receive(on: DispatchQueue.main)
			.map { steps in
				var result: [DataPoint] = []
				for i in (0..<steps.count) {
					result.append(DataPoint(value: steps[i].0, label: "\(steps[i].1)/\(steps[i].2)", legend: AppConstant.legend))
				}
				
				result = result.sorted(by: { value1, value2 in
					return "\(value1.label)" < "\(value2.label)"
				})
				return result
			}
			.assign(to: \.last7DaysDataPoints, on: self)
			.store(in: &cancellable)
		
		self.healthKitManager.$thisMonthSteps
			.receive(on: DispatchQueue.main)
			.map { steps in
				var result: [DataPoint] = []
				for i in (0..<steps.count) {
					result.append(DataPoint(value: steps[i].0, label: "\(steps[i].1)/\(steps[i].2)", legend: AppConstant.legend))
				}
				
				result = result.sorted(by: { value1, value2 in
					return "\(value1.label)" < "\(value2.label)"
				})
				return result
			}
			.assign(to: \.last30DaysDataPoints, on: self)
			.store(in: &cancellable)
		
		fetchLastSevenDaysHistory()
		fetchLast30DaysHistory()
	}
	
	func switchView(_ historyType: HistoryType) {
		self.historyType = historyType
	}
	
	func fetchLastSevenDaysHistory() {
		Task {
			await self.healthKitManager.fetchWeeksData()
		}
	}
	
	
	func fetchLast30DaysHistory() {
		Task {
			await self.healthKitManager.fetchMonthData()
		}
	}
}
