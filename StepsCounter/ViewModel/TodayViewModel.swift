//
//  TodayViewModel.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/20/23.
//



import Foundation
import Combine

class TodayViewModel: ObservableObject {
	
	private var healthKitManager: HealthKitManager
	
	@Published
	var steps: Double = 0
	var cancellable: Set<AnyCancellable> = []
	
	init(healthKitManager: HealthKitManager) {
		self.healthKitManager = healthKitManager
		setup()
	}
	
	func setup() {
		self.healthKitManager.$stepCountToday
			.receive(on: DispatchQueue.main)
			.assign(to: \.steps, on: self)
			.store(in: &cancellable)
		Task {
			await healthKitManager.fetchTodaysStepCount()
		}
	}
	
}
