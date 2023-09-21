//
//  LoginView.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/21/23.
//



import SwiftUI

struct LoginView: View {
	
	@EnvironmentObject
	var appSessionState: SessionService
	
	@ObservedObject
	var viewModel: LoginViewModel = LoginViewModel(apiService: StepCounterApiService())
	
	var body: some View {
		VStack {
			Text("StepsCounter")
				.font(.title)
			Spacer()
				.frame(height: 50)
			TextField("Username", text: $viewModel.userName)
				.textFieldStyle(.roundedBorder)
			Spacer()
				.frame(height: 20)
			SecureField("Password", text: $viewModel.password)
				.textFieldStyle(.roundedBorder)
			Spacer()
				.frame(height: 20)
			Button {
				viewModel.login()
			} label: {
				Text("Sign In")
					.frame(maxWidth: .infinity)
			}
			.buttonStyle(.borderedProminent)
			.disabled(viewModel.isLoggingIn)
			Spacer()
				.frame(height: 20)
			if !viewModel.errMsg.isEmpty {
				Text(viewModel.errMsg)
					.font(.caption)
					.foregroundColor(.red)
			}
//			Spacer()
//			Button("Don't have an account? Sign up") {
//				print("Pressed sign up button!")
//			}
		}
		.padding(.horizontal, 20)
		.onAppear {
			viewModel.setup(sessionService: appSessionState)
		}
	}
}

struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
		LoginView()
	}
}
