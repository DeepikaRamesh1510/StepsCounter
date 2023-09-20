//
//  ContentView.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/18/23.
//



import SwiftUI

struct ContentView: View {
	@EnvironmentObject
	var healthKitManager: HealthKitManager
	
    var body: some View {
		TabbarView().environmentObject(HealthKitManager.shared)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
