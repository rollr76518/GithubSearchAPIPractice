//
//  DataManager.swift
//  GithubSearchAPIPractice
//
//  Created by Ryan on 2019/12/10.
//  Copyright © 2019 Hanyu. All rights reserved.
//

import Foundation

class DataManager {
	
	static let shared = DataManager()
}

extension DataManager {
	
	/// Get Users by userName and page as query arguments.
	/// - Parameter userName: looking for user with.
	/// - Parameter page: for pagination, value is 1 when argument set nil.
	/// - Parameter completionHandler: return users and next page number. Return error when API error and parse error.
	func users(userName: String, page: Int? = nil, completionHandler: @escaping (Result<([User], Int?), Error>) -> Void) {
		let apiClient = APIClient()
		
		apiClient.fetchUsers(userName, page: page) { (result) in
			switch result {
			case .success(let (data, nextPagePath)):
				let decoder = JSONDecoder()
				decoder.keyDecodingStrategy = .convertFromSnakeCase
				do {
					let response = try decoder.decode(APIResponseObject<User>.self, from: data)
					completionHandler(.success((response.items, self.parseNextPagePath(nextPagePath))))
				} catch {
					completionHandler(.failure(error))
				}

			case .failure(let error):
				completionHandler(.failure(error))
			}
		}
	}
}

// Helper
private extension DataManager {
	//TODO: 測試待補
	func parseNextPagePath(_ path: String?) -> Int? {
		if let nextPagePath = path,
			let urlComponents = URLComponents(string: nextPagePath),
			let queryItems = urlComponents.queryItems,
			let page = queryItems.first(where: { $0.name == "page" })?.value {
			return Int(page)
		} else {
			return nil
		}
	}
}
