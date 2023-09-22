//
//  ContentView.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/18/23.
//



import SwiftUI

struct ContentView: View {
	@StateObject
	var appSessionState: SessionService = SessionService(keychain: keychain)
	
	var body: some View {
		switch appSessionState.state {
			case .login:
				LoginView()
					.environmentObject(appSessionState)
			case .tabView:
				TabbarView()
					.environmentObject(appSessionState)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
