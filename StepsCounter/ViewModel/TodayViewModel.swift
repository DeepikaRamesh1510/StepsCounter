//
//  TodayViewModel.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/20/23.
//



import Foundation
import Combine
import UserDefaultsService


class TodayViewModel: ObservableObject {
	
	private var healthKitManager: HealthKitManager
	
	@Published
	var steps: Double = 0
	var cancellable: Set<AnyCancellable> = []
	var userDefaultService: UserDefaultsService
	
	var timerPublisher = Timer.publish(every: 18000, on: .main, in: .default)
	var timerCancellable: AnyCancellable? = nil
	
	var apiService: APIServiceProtocol
	
	init(
		healthKitManager: HealthKitManager,
		userDefaultsService: UserDefaultsService,
		apiService: APIServiceProtocol
	) {
		self.healthKitManager = healthKitManager
		self.userDefaultService = userDefaultsService
		self.apiService = apiService
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
			await uploadData()
		}
	}
	
	func uploadData() async {
		let payload = StepsModel(
			name: "user1",
			stepsDate: "2023-09-10T18:19:08.725Z",
			stepsDateTime: "2023-09-10T18:19:08.725Z",
			stepsCount: 5,
			stepsTotalByDay: 10
		)
		
		let result = await apiService.sendRequest(
			endpoint: StepCounterEndPoint.uploadSteps(payload),
			responseModel: StepsModel.self
		)
		print(result)
	}
	
	func stopTimer() {
		timerCancellable?.cancel()
	}
	
	deinit {
		stopTimer()
	}
}
