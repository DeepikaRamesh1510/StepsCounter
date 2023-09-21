//
//  SessionService.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/21/23.
//



import Foundation
import UserDefaultsService
import KeychainAccess

class SessionService: ObservableObject {
	
	enum SessionState: String, UserDefaultsKeyProtocol {
		case hasLoggedIn
		case lastSynced
		case isOnboardingCompleted
		var key: String { return self.rawValue }
	}
	
	enum RootView {
		case login
		case tabView
	}
	
	@Published
	var state: RootView = .login
	
	@UserDefault<Bool>(key: SessionState.hasLoggedIn, defaultValue: false)
	var hasLoggedInSession: Bool
	
	@CodableUserDefault<User?>(key: StepCounterUDKeys.appUser, defaultValue: nil)
	private var _appUser: User?
	
	var appUser: User! { return _appUser }
	var keychain: Keychain
	
	init(keychain: Keychain) {
		self.keychain = keychain
		setupRootView()
	}
	

	
	func setupRootView() {
		if !hasLoggedInSession {
			state = .login
			return 
		}
		
		state = .tabView
	}
	
	func setupSession(with authResponse: AuthResponseModel) -> Bool {
		keychain["JWT"] = authResponse.jwt
		_appUser = authResponse.user
		
		if _appUser == nil || keychain["JWT"] == nil {
			return false
		} else {
			hasLoggedInSession = true
			DispatchQueue.main.async {
				self.state = .tabView
			}
			
			return true
		}
	}
	
	func clearSession() {
		keychain["JWT"] = nil
		_appUser = nil
		hasLoggedInSession = false
		DispatchQueue.main.async {
			self.state = .login
		}
	}
}
