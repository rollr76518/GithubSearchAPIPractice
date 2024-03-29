//
//  GithubSearchAPIPracticeTests.swift
//  GithubSearchAPIPracticeTests
//
//  Created by Ryan on 2019/12/9.
//  Copyright © 2019 Hanyu. All rights reserved.
//

import XCTest
@testable import GithubSearchAPIPractice

class GithubSearchAPIPracticeTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}

	func testFetchUsers() {
		expectation(description: "Testing fetch users", timeout: 15.0) { (done) in
			let apiClient = APIClient()
			
			apiClient.fetchUsers("ro", page: 2) { (result) in
				switch result {
				case .success(let (data, nextPagePath)):
					if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
						XCTAssertNotNil(json)
					} else {
						XCTFail("json should be parsed.")
					}
					XCTAssertNotNil(nextPagePath)
				case .failure(let error):
					XCTFail(error.localizedDescription)
				}
				done()
			}
		}
	}

	func testParseUsersResponse() {
		expectation(description: "Testing parse users response", timeout: 15.0) { (done) in
			guard let filePath = Bundle(for: Swift.type(of: self)).path(forResource: "api_search_users", ofType: "json"),
				let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
					print("file is not exist or something wrong.")
					return
			}
			
			let decoder = JSONDecoder()
			decoder.keyDecodingStrategy = .convertFromSnakeCase

			do {
				let response = try decoder.decode(APIResponseObject<User>.self, from: data)
				XCTAssertNotNil(response)
				
				XCTAssertEqual(response.totalCount, 40)
				XCTAssertEqual(response.incompleteResults, false)
				
				guard let first = response.items.first else {
					XCTFail("Response items should have a item at least.")
					done()
					return
				}
				
				XCTAssertEqual(first.avatarUrl.absoluteString, "https://avatars0.githubusercontent.com/u/34742481?v=4")
				XCTAssertEqual(first.login, "Rollr-io")
			} catch {
				XCTFail(error.localizedDescription)
			}
			
			done()
		}
	}
	
	func testParseHeaderLinks() {
		let headerLinks = #"<https://api.github.com/search/users?q=ro&page=1>; rel="prev", <https://api.github.com/search/users?q=ro&page=3>; rel="next", <https://api.github.com/search/users?q=ro&page=34>; rel="last", <https://api.github.com/search/users?q=ro&page=1>; rel="first""#
		
		let apiClient = APIClient()
		
		guard let nextPagePath = apiClient.nextPagePath(headerLinks: headerLinks) else {
			XCTFail("Parse header failed.")
			return
		}
		
		XCTAssertEqual(nextPagePath, "https://api.github.com/search/users?q=ro&page=3")
	}
	
	func testGetUsers() {
		expectation(description: "Testing parse users response", timeout: 15.0) { (done) in
			DataManager.shared.users(userName: "ro", page: 3) { (result) in
				switch result {
				case .success(let (users, page)):
					XCTAssertNotNil(users)
					XCTAssertNotNil(page)
				case .failure(let error):
					XCTFail(error.localizedDescription)
				}
			}
		}
	}
}
