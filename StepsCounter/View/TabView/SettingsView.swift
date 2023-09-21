//
//  SettingsView.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/18/23.
//



import SwiftUI

struct SettingsView: View {
	
	@EnvironmentObject
	var sessionService: SessionService
	
	@ObservedObject
	var viewModel: SettingsViewModel = SettingsViewModel()
	
    var body: some View {
		VStack {
			Text(viewModel.userName)
				.font(.largeTitle)
			Text(viewModel.email)
				.font(.subheadline)
			Spacer()
				.frame(height: 50)
			Button("Logout") {
				viewModel.logout()
			}
			.buttonStyle(.borderedProminent)
			.tint(.red)
			Spacer()
		}
		.navigationBarHidden(true)
		.onAppear {
			viewModel.setup(sessionService: sessionService)
		}
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
