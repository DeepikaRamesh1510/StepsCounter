//
//  TodayView.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/18/23.
//



import SwiftUI
import HealthKit

struct TodayView: View {
	@EnvironmentObject
	var healthKitManager: HealthKitManager
	
	lazy var viewModel: TodayViewModel = TodayViewModel(healthKitManager: self.healthKitManager)
	
    var body: some View {
		Text("Steps count: \(healthKitManager.stepCountToday)")
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}


struct TodayViewModel {
	
//	@ObservedObject
	var healthKitManager: HealthKitManager
	
	init(healthKitManager: HealthKitManager) {
		self.healthKitManager = healthKitManager
	}
	
}
