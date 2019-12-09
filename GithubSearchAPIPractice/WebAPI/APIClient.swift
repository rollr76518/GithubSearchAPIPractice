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
	
	func fetchUsers(_ userName: String, page: Int? = nil, completionHandler: @escaping (Result<(Data, String?), Error>) -> Void)  {
		var components = URLComponents()
		components.scheme = "https"
		components.host = "api.github.com"
		components.path = "/search/users"
		components.queryItems = [
			URLQueryItem(name: "q", value: userName),
			URLQueryItem(name: "page", value: "\(page ?? 1)") //Default 是 1
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
				if let httpURLResponse = response as? HTTPURLResponse,
					let links = httpURLResponse.allHeaderFields["Link"] as? String {
					let nextPagePath = self.nextPagePath(headerLinks: links)
					completionHandler(.success((data, nextPagePath)))
				} else {
					completionHandler(.success((data, nil)))
				}
			} else {
				// TODO: 如果到這個情況要噴錯，理論上不會過來
			}
		}
		
		task.resume()
		
		session.finishTasksAndInvalidate()
	}
}

// Helper
extension APIClient {
	
	func nextPagePath(headerLinks: String) -> String? {
		let links = headerLinks.components(separatedBy: ",")
		
		let dictionary = links.reduce([:], { (result, link) -> [String: String] in
			var result = result
			let components = link.components(separatedBy:"; ")
			let cleanPath = components[0].trimmingCharacters(in: CharacterSet(charactersIn: " <>"))
			result[components[1]] = cleanPath
			return result
		})
		
		return dictionary["rel=\"next\""]
	}
}
