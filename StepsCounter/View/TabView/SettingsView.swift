//
//  SettingsView.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/18/23.
//



import SwiftUI

struct SettingsView: View {
	var userName: String = "Test user"
    var body: some View {
        Text(userName)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
