//
//  SettingsViewModel.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/21/23.
//



import Foundation

class SettingsViewModel: ObservableObject {
	@Published
	var userName: String = ""
	
	@Published
	var email: String = ""
	
	var sessionService: SessionService!
	
	func setup(sessionService: SessionService) {
		self.sessionService = sessionService
		userName = sessionService.appUser?.username ?? "AppUser"
		email = sessionService.appUser?.email ?? "AppUser"
	}
	
	func logout() {
		sessionService.clearSession()
	}
}
