//
//  TodayView.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/18/23.
//



import SwiftUI
import HealthKit
import Combine
import UserDefaultsService

struct TodayView: View {
	
	@ObservedObject
	var viewModel: TodayViewModel = TodayViewModel(
		healthKitManager: HealthKitManager.shared,
		userDefaultsService: UserDefaultsService.shared
	)
	
    var body: some View {
		Text("Steps count: \(Int(self.viewModel.steps))")
			.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
				viewModel.updateView()
			}
			.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
				viewModel.stopTimer()
			}
	}
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}

