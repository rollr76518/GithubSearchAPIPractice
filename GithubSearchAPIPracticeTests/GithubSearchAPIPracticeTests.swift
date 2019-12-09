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
			
			apiClient.fetchUsers("rollr") { (result) in
				switch result {
				case .success(let data):
					if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
						XCTAssertNotNil(json)
					} else {
						XCTFail("json should be parsed.")
					}
				case .failure(let error):
					XCTFail(error.localizedDescription)
				}
				done()
			}
		}
	}

}
