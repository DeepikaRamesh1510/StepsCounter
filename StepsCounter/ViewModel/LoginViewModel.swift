//
//  LoginViewModel.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/21/23.
//



import Foundation

class LoginViewModel: ObservableObject  {
	
	@Published
	var userName: String = ""
	
	@Published
	var password: String = ""
	
	@Published
	var isLoggingIn = false
	
	@Published
	var errMsg = ""
	
	var sessionService: SessionService!
	var apiService: APIServiceProtocol
	
	init(
		apiService: APIServiceProtocol
	) {
		self.apiService = apiService
	}
	
	func setup(sessionService: SessionService) {
		self.sessionService = sessionService
	}
	
	func login() {
		isLoggingIn = true
		let payload = AuthUploadModel(identifier: userName, password: password)
		Task {
			let result = await apiService.sendRequest(
				endpoint: StepCounterEndPoint.login(payload),
				responseModel: AuthResponseModel.self
			)
			
			switch result {
				case .success(let authResponse):
					guard !sessionService.setupSession(with: authResponse) else {
						return
					}
					DispatchQueue.main.async {
						self.isLoggingIn = false
						self.errMsg = "Unable to setup session"
					}
				case .failure(let failure):
					DispatchQueue.main.async {
						self.isLoggingIn = false
						switch failure {
							case .badRequest:
								self.errMsg = "Invalid username / password"
							default:
								self.errMsg = "Unable to login!"
						}
					}
			}
		}
	}
	
}
