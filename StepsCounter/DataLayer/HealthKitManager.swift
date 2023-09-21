	//
	//  HealthKitManager.swift
	//  StepsCounter
	//
	//  Created by Deepika Ramesh on 9/18/23.
	//



import Foundation
import HealthKit
import Combine


class HealthKitManager: ObservableObject {
	
	
	static let shared = HealthKitManager()
	
	var healthStore = HKHealthStore()
	@Published
	var stepCountToday: Double = 0
	@Published
	var thisWeekSteps: [Int] = Array(repeating: 0, count: 7)
	
	func requestAuthorization() {
		
		let toReads = Set([
			HKObjectType.quantityType(forIdentifier: .stepCount)!
		])
		
		guard HKHealthStore.isHealthDataAvailable() else {
			print("health data not available!")
			return
		}
		
		healthStore.requestAuthorization(toShare: nil, read: toReads) {
			success, error in
			if success {
				print(success)
			} else {
				print("\(String(describing: error))")
			}
		}
	}
	
	func fetchWeeksData() {
			//		let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
			//		let status = healthStore.authorizationStatus(for: stepCountType)
			//
			////		switch status {
			////			case .notDetermined:
			////				requestAuthorization()
			////			case .sharingDenied:
			////				break
			////			case .sharingAuthorized:
			//				let calendar = Calendar.current
			//				let today = calendar.startOfDay(for: Date())
			//
			//					// Find the start date (Monday) of the current week
			//				guard let startOfWeek =  else {
			//					print("Failed to calculate the start date of the week.")
			//					return
			//				}
			//
			//					// Find the end date (Sunday) of the current week
			//				guard let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) else {
			//					print("Failed to calculate the end date of the week.")
			//					return
			//				}
			//
			//				let predicate = HKQuery.predicateForSamples(
			//					withStart: startOfWeek,
			//					end: endOfWeek,
			//					options: .strictStartDate
			//				)
			//
			//				let query = HKStatisticsCollectionQuery(
			//					quantityType: stepCountType,
			//					quantitySamplePredicate: predicate,
			//					options: .cumulativeSum, // fetch the sum of steps for each day
			//					anchorDate: startOfWeek,
			//					intervalComponents: DateComponents(day: 1) // interval to make sure the sum is per 1 day
			//				)
			//
			//				query.initialResultsHandler = { _, result, error in
			//					guard let result = result else {
			//						if let error = error {
			//							print("An error occurred while retrieving step count: \(error.localizedDescription)")
			//						}
			//						return
			//					}
			//
			//					result.enumerateStatistics(from: startOfWeek, to: endOfWeek) { statistics, _ in
			//						if let quantity = statistics.sumQuantity() {
			//							let steps = Int(quantity.doubleValue(for: HKUnit.count()))
			//							let day = calendar.component(.weekday, from: statistics.startDate)
			//							DispatchQueue.main.async {
			//								self.thisWeekSteps[day - 1] = steps
			//							}
			//						}
			//					}
			//				}
			//
			//				healthStore.execute(query)
			////			@unknown default:
			////				break
			////		}
	}
	
	func fetchTodaysStepCount() async {
		
		let predicate = HKQuery.predicateForSamples(
			withStart: DateHelper.startOfToday,
			end: DateHelper.currentDate
		)
		
		let stepType = HKQuantityType(.stepCount)
		let stepsToday = HKSamplePredicate.quantitySample(type: stepType, predicate: predicate)
		let sumOfStepsQuery = HKStatisticsQueryDescriptor(predicate: stepsToday, options: .cumulativeSum)
		
		Task {
			do {
				let stepCount = try await sumOfStepsQuery.result(for: self.healthStore)?
					.sumQuantity()?
					.doubleValue(for: HKUnit.count())
				stepCountToday = stepCount ?? 0
			} catch {
				stepCountToday = 0
			}
		}
		
	}
	
}
