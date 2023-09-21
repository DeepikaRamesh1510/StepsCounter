//
//  TodayViewModel.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/20/23.
//



import Foundation
import Combine
import UserDefaultsService

enum StepCounterUDKeys: String, UserDefaultsKeyProtocol {
	var key: String { self.rawValue }
	case todayStepCountLastRetreivedTime
}

class TodayViewModel: ObservableObject {
	
	private var healthKitManager: HealthKitManager
	
	@Published
	var steps: Double = 0
	var cancellable: Set<AnyCancellable> = []
	var userDefaultService: UserDefaultsService
	
	var timerPublisher = Timer.publish(every: 18000, on: .main, in: .default)
	var timerCancellable: AnyCancellable? = nil
	
	init(healthKitManager: HealthKitManager, userDefaultsService: UserDefaultsService) {
		self.healthKitManager = healthKitManager
		self.userDefaultService = userDefaultsService
		setup()
	}
	
	func setup() {
		self.healthKitManager.$stepCountToday
			.receive(on: DispatchQueue.main)
			.assign(to: \.steps, on: self)
			.store(in: &cancellable)
		updateView()
	}
	
	func updateView() {
		if timerCancellable != nil {
			stopTimer()
		}
		fetchTodaysStepCount(Date())
		timerCancellable = timerPublisher
			.autoconnect()
			.sink { date in
				self.fetchTodaysStepCount(date)
			}
	}
	
	func fetchTodaysStepCount(_ date: Date) {
		Task {
			await healthKitManager.fetchTodaysStepCount()
			userDefaultService.set(date, forKey: StepCounterUDKeys.todayStepCountLastRetreivedTime)
		}
	}
	
	func stopTimer() {
		timerCancellable?.cancel()
	}
	
	deinit {
		stopTimer()
	}
}
