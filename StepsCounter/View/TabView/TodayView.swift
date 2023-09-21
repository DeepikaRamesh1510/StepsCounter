//
//  TodayView.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/18/23.
//



import SwiftUI
import HealthKit
import Combine

struct TodayView: View {
	
	@ObservedObject
	var viewModel: TodayViewModel = TodayViewModel(healthKitManager: HealthKitManager.shared)
	
    var body: some View {
		Text("Steps count: \(Int(self.viewModel.steps))")
	}
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}

