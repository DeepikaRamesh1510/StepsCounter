//
//  TodayViewModel.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/20/23.
//



import Foundation
import Combine
import UserDefaultsService
import SwiftUICharts


class TodayViewModel: ObservableObject {
	
	private var healthKitManager: HealthKitManager
	
	@Published
	var steps: Double = 0
	
	@Published
	var hourlyDataPoints: [DataPoint] = []
	
	@Published
	var progressStatus: Double = 0.0
	
	var cancellable: Set<AnyCancellable> = []
	var userDefaultService: UserDefaultsService
	
	var timerPublisher = Timer.publish(every: 18000, on: .main, in: .default)
	var timerCancellable: AnyCancellable? = nil
	
	var apiService: APIServiceProtocol
	var sessionService: SessionService?
	
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
	
	func setup(sessionService: SessionService) {
		self.sessionService = sessionService
		Task {
			await uploadData()
		}
	}
	
	func setup() {
		self.healthKitManager.$stepCountToday
			.receive(on: DispatchQueue.main)
			.assign(to: \.steps, on: self)
			.store(in: &cancellable)
		
		self.healthKitManager.$stepCountToday
			.receive(on: DispatchQueue.main)
			.map { value in
				value / 10000
			}
			.assign(to: \.progressStatus, on: self)
			.store(in: &cancellable)
		
		self.healthKitManager.$todayHourlyStepCount
			.receive(on: DispatchQueue.main)
			.map { steps in
				var result: [DataPoint] = []
				for i in (0..<steps.count) {
					result.append(DataPoint(value: steps[i], label: "", legend: AppConstant.legend))
				}
				
				return result
			}
			.assign(to: \.hourlyDataPoints, on: self)
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
			await healthKitManager.fetchTodayHourlyData()
			userDefaultService.set(date, forKey: StepCounterUDKeys.todayStepCountLastRetreivedTime)
			
			guard sessionService != nil else { return }
			await uploadData()
		}
	}
	
	func uploadData() async {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
		let date = Date()
		let dateString = dateFormatter.string(from: date)
		let payload = StepsUploadModel(
			name: sessionService?.appUser.username ?? "",
			stepsDate: dateString,
			stepsDateTime: dateString,
			stepsCount: Int(steps),
			stepsTotalByDay: Int(steps)
		)
		
		let result = await apiService.sendRequest(
			endpoint: StepCounterEndPoint.uploadSteps(payload),
			responseModel: StepsResponseModel.self
		)
		
		switch result {
			case .success(let value):
				print(value)
			case .failure(let err):
				print(err.localizedDescription)
		}
	}
	
	func stopTimer() {
		timerCancellable?.cancel()
	}
	
	deinit {
		stopTimer()
	}
}
