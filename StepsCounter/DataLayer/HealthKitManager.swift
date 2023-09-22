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
	var todayHourlyStepCount: [Double] = Array(repeating: 0, count: 24)
	
	@Published
	var thisWeekSteps: [(Double, Int, Int)] = Array(repeating: (0, 0, 0), count: 7)
	
	var weeksResult: HKStatisticsCollection? = nil
	
	@Published
	var thisMonthSteps: [(Double, Int, Int)] = Array(repeating: (0, 0, 0), count: 30)
	
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
	
	func fetchMonthData() async {
		self.thisMonthSteps = Array(repeating: (0, 0, 0), count: 30)
		let endDate = DateHelper.currentDate
		let startDate = DateHelper.calendar.date(byAdding: .day, value: -30, to: DateHelper.startOfToday)!
		
		let predicate = HKQuery.predicateForSamples(
			withStart: startDate,
			end: endDate
		)
		
		let stepType = HKQuantityType(.stepCount)
		let stepsMonth = HKSamplePredicate.quantitySample(type: stepType, predicate: predicate)
		
		let sumOfStepsQuery = HKStatisticsCollectionQueryDescriptor(
			predicate: stepsMonth,
			options: .cumulativeSum,
			anchorDate: startDate,
			intervalComponents: DateComponents(day: 1)
		)
		
		do {
			let stepCounts = try await sumOfStepsQuery.result(for: self.healthStore)
			stepCounts.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
				
				let day = DateHelper.calendar.component(.weekday, from: statistics.startDate)
				let date = DateHelper.calendar.component(.day, from: statistics.startDate)
				let month = DateHelper.calendar.component(.month, from: statistics.startDate)
				
				if let quantity = statistics.sumQuantity() {
					let steps = quantity.doubleValue(for: HKUnit.count())
					self.thisMonthSteps[day - 1] = (steps, month, date)
				} else {
					self.thisMonthSteps[day - 1] = (0, month, date)
				}
			}
			
		} catch {
			print(error.localizedDescription)
		}
	}
	
	func fetchWeeksData() async {
		self.thisWeekSteps = Array(repeating: (0, 0, 0), count: 7)
		
		let endDate = DateHelper.endOfToday
		let startDate = DateHelper.calendar.date(
			byAdding: .day,
			value: -7, to: DateHelper.startOfToday
		)!
		
		let predicate = HKQuery.predicateForSamples(
			withStart: startDate,
			end: endDate,
			options: [.strictStartDate]
		)
		
		let stepType = HKQuantityType(.stepCount)
		let stepsWeek = HKSamplePredicate.quantitySample(type: stepType, predicate: predicate)
		
		let sumOfStepsQuery = HKStatisticsCollectionQueryDescriptor(
			predicate: stepsWeek,
			options: .cumulativeSum,
			anchorDate: startDate,
			intervalComponents: DateComponents(day: 1)
		)
		
		do {
			weeksResult = try await sumOfStepsQuery.result(for: self.healthStore)
			
			weeksResult?.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
				
				let day = DateHelper.calendar.component(.weekday, from: statistics.startDate)
				let date = DateHelper.calendar.component(.day, from: statistics.startDate)
				let month = DateHelper.calendar.component(.month, from: statistics.startDate)
				if let quantity = statistics.sumQuantity() {
					let steps = quantity.doubleValue(for: HKUnit.count())
					self.thisWeekSteps[day - 1] = (steps, month, date)
				} else {
					self.thisWeekSteps[day - 1] = (0, month, date)
				}
			}
		} catch {
			print(error.localizedDescription)
		}
	}
	
	func fetchTodayHourlyData() async {
		self.todayHourlyStepCount = Array(repeating: 0, count: 24)
		
		let endDate = DateHelper.endOfToday
		let startDate =  DateHelper.startOfToday
		
		let predicate = HKQuery.predicateForSamples(
			withStart: startDate,
			end: endDate
		)
		
		let stepType = HKQuantityType(.stepCount)
		let stepsToday = HKSamplePredicate.quantitySample(type: stepType, predicate: predicate)
		
		let sumOfStepsQuery = HKStatisticsCollectionQueryDescriptor(
			predicate: stepsToday,
			options: .cumulativeSum,
			anchorDate: endDate,
			intervalComponents: DateComponents(hour: 1)
		)
		
		do {
			weeksResult = try await sumOfStepsQuery.result(for: self.healthStore)
		
			weeksResult?.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
				
				let hour = (DateHelper.calendar.component(.hour, from: statistics.startDate) + 1) % 24
				
				if let quantity = statistics.sumQuantity() {
					let steps = quantity.doubleValue(for: HKUnit.count())
					self.todayHourlyStepCount[hour] = steps
				}
			}
		} catch {
			print(error.localizedDescription)
		}
	}
	
	func fetchTodaysStepCount() async {
		
		let predicate = HKQuery.predicateForSamples(
			withStart: DateHelper.startOfToday,
			end: DateHelper.calendar.date(byAdding: .day, value: 1, to: DateHelper.startOfToday)
		)
		
		let stepType = HKQuantityType(.stepCount)
		let stepsToday = HKSamplePredicate.quantitySample(type: stepType, predicate: predicate)
		let sumOfStepsQuery = HKStatisticsQueryDescriptor(predicate: stepsToday, options: .cumulativeSum)
		
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
