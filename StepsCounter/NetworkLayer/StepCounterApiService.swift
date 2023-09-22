//
//  StepCounterApiService.swift
//  StepsCounter
//
//  Created by Deepika Ramesh on 9/21/23.
//



import Foundation

protocol APIServiceProtocol {
	func sendRequest<T: Decodable>(
		endpoint: Endpoint,
		responseModel: T.Type
	) async -> Result<T, NetworkError>
}

extension APIServiceProtocol {
	
	func sendRequest<T: Decodable>(
		endpoint: Endpoint,
		responseModel: T.Type
	) async -> Result<T, NetworkError> {
		
		var urlComponents = URLComponents()
		urlComponents.scheme = endpoint.scheme
		urlComponents.host = endpoint.host
		urlComponents.path = endpoint.path
		
		guard let url = urlComponents.url else {
			return .failure(.custom("Invalid URL!"))
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = endpoint.method.rawValue
		request.allHTTPHeaderFields = endpoint.header
		
		if let body = endpoint.body {
			request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
		}
		
		do {
			let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
			
			guard let response = response as? HTTPURLResponse else {
				return .failure(.custom("No Response"))
			}
			
			switch response.statusCode {
				case 200...299:
					guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
						return .failure(.decode)
					}
					return .success(decodedResponse)
				case 400:
					return .failure(.badRequest)
				case 401:
					return .failure(.unauthorized)
				default:
					return .failure(.custom("Unhandled status code: \(response.statusCode)"))
			}
		} catch {
			return .failure(.custom(error.localizedDescription))
		}
	}
}


struct StepCounterApiService: APIServiceProtocol {
	
}
