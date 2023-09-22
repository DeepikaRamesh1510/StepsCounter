//
//  DataController.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/21/23.
//



import Foundation
import CoreData

class DataController {
	let container = NSPersistentContainer(name: "StepsCounter")
	
	static var shared: DataController = .init()
	
	private init() {
		container.loadPersistentStores { description, error in
			if let error = error {
				print("Core Data failed to load: \(error.localizedDescription)")
			}
		}
	}
}
