	//
	//  StepsBaseView.swift
	//  StepsCounter
	//
	//  Created by Deepika Ramesh on 9/18/23.
	//



import SwiftUI
import HealthKit

enum StepsViewSegment : String, CaseIterable {
	case today = "Today"
	case history = "History"
}

struct StepsBaseView: View {
	
	@State
	var stepsViewSegment : StepsViewSegment = .today
	var viewModel: StepsBaseViewModel = StepsBaseViewModel(healthKitManager: HealthKitManager.shared)
	
	var body: some View {
		VStack {
			HStack {
				Picker("", selection: $stepsViewSegment) {
					ForEach(StepsViewSegment.allCases, id: \.self) { option in
						Text(option.rawValue)
					}
				}
				.pickerStyle(SegmentedPickerStyle())
				.padding()
			}
			
			switch stepsViewSegment {
				case .today:
					TodayView()
				case .history:
					HistoryView()
			}
			Spacer()
		}.onAppear {
			viewModel.requestAuthorization()
		}
	}
	
	
}

struct StepsBaseView_Previews: PreviewProvider {
	static var previews: some View {
		StepsBaseView()
	}
}
