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
import SwiftUICharts

struct TodayView: View {
	
	@ObservedObject
	var viewModel: TodayViewModel = TodayViewModel(
		healthKitManager: HealthKitManager.shared,
		userDefaultsService: UserDefaultsService.shared,
		apiService: StepCounterApiService(),
		dataController: DataController.shared
	)
	
	@EnvironmentObject
	var sessionService: SessionService
	
	var body: some View {
		VStack {
			Text("\(Int(viewModel.steps))")
				.font(.largeTitle)
			Text("Steps")
				.font(.headline)
			Spacer()
			ProgressView(value: viewModel.progressStatus)
				.progressViewStyle(
					CustomProgressViewStyle(height: 100.0, bottomLabelString: "10,000 Steps")
				)
				.padding([.trailing, .leading], 30)
			Spacer()
			BarChartView(dataPoints: viewModel.hourlyDataPoints)
				.padding(30)
		}
		.onAppear {
			viewModel.setup(sessionService: sessionService)
		}
		.onReceive(
			NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
		) { _ in
			viewModel.updateView()
		}
		.onReceive(
			NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
		) { _ in
			viewModel.stopTimer()
		}
	}
}

struct TodayView_Previews: PreviewProvider {
	static var previews: some View {
		TodayView()
	}
}

