	//
	//  CustomProgressViewStyle.swift
	//  StepsCounter
	//
	//  Created by Deepika Ramesh on 9/21/23.
	//



import SwiftUI

struct CustomProgressViewStyle: ProgressViewStyle {
	
	var color: Color = .blue
	var height: Double = 20.0
	var labelFontStyle: Font = .body
	var bottomLabelString: String = ""
	
	func makeBody(configuration: Configuration) -> some View {
		
		let progress = configuration.fractionCompleted ?? 0.0
		
		GeometryReader { geometry in
			
			VStack(alignment: .leading) {
				
				RoundedRectangle(cornerRadius: 10.0)
					.fill(Color(uiColor: .systemGray5))
					.frame(height: height)
					.frame(width: geometry.size.width)
					.overlay(alignment: .leading) {
						RoundedRectangle(cornerRadius: 10.0)
							.fill(color)
							.frame(width: geometry.size.width * progress)
					}
				HStack {
					Spacer()
					Text(bottomLabelString)
						.font(.caption)
				}
			}
			
		}
	}
}

