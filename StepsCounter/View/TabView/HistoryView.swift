//
//  HistoryView.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/18/23.
//



import SwiftUI
import SwiftUICharts

struct HistoryView: View {

	@ObservedObject
	var viewModel: HistoryViewModel = HistoryViewModel(healthKitManager: HealthKitManager.shared)
	
    var body: some View {
		VStack {
			HStack {
				Button("7 Days") {
					viewModel.switchView(.seven)
				}
				.buttonStyle(.borderedProminent)
				.tint(viewModel.historyType == .seven ? .green : .blue)
				Button("30 Days") {
					viewModel.switchView(.thirty)
				}
				.buttonStyle(.borderedProminent)
				.tint(viewModel.historyType == .thirty ? .green : .blue)
			}
			Spacer()
			BarChartView(
				dataPoints: viewModel.historyType == .seven
				? viewModel.last7DaysDataPoints
				: viewModel.last30DaysDataPoints
			)
			.chartStyle(BarChartStyle(showLabels: viewModel.historyType == .seven))
			.padding(20)
			Spacer()
		}.onAppear {
			viewModel.fetchLastSevenDaysHistory()
		}
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
