//
//  APIClient.swift
//  GithubSearchAPIPractice
//
//  Created by Ryan on 2019/12/9.
//  Copyright © 2019 Hanyu. All rights reserved.
//

import Foundation

class APIClient {
	
	deinit {
		print("\(#file): \(#function)")
	}
	
	func fetchUsers(_ userName: String, completionHandler: @escaping (Result<Data, Error>) -> Void)  {
		var components = URLComponents()
		components.scheme = "https"
		components.host = "api.github.com"
		components.path = "/search/users"
		components.queryItems = [
			URLQueryItem(name: "q", value: userName)
		]
		
		guard let url = components.url else {
			// TODO: 如果到這個情況要噴錯，理論上不會過來
			return
		}
		
		let sessionConfig = URLSessionConfiguration.default
		
		let session = URLSession(configuration: sessionConfig)
		
		let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15.0)
		
		let task = session.dataTask(with: request) { (data, response, error) in
			if let error = error {
				completionHandler(.failure(error))
			} else if let data = data {
				completionHandler(.success(data))
			} else {
				// TODO: 如果到這個情況要噴錯，理論上不會過來
			}
		}
		
		task.resume()
		
		session.finishTasksAndInvalidate()
	}
}
