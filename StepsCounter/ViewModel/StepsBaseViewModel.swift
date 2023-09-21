//
//  StepsBaseViewModel.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/20/23.
//



import Foundation

struct StepsBaseViewModel {
	
	var healthKitManager: HealthKitManager
	
	init(healthKitManager: HealthKitManager) {
		self.healthKitManager = healthKitManager
	}
	
	func requestAuthorization() {
		self.healthKitManager.requestAuthorization()
	}
}
