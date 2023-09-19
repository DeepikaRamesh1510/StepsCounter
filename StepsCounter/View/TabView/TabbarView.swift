//
//  TabbarView.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/18/23.
//



import SwiftUI

struct TabbarView: View {
    var body: some View {
		TabView {
			StepsBaseView()
				.tabItem {
					Label("Steps", systemImage: "figure.walk")
				}
			SettingsView()
				.tabItem {
					Label("Settings", systemImage: "gear")
				}
		}
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
    }
}
