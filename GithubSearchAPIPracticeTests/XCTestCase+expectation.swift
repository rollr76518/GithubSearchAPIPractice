//
//  XCTestCase+expectation.swift
//  GithubSearchAPIPracticeTests
//
//  Created by Ryan on 2019/12/9.
//  Copyright © 2019 Hanyu. All rights reserved.
//

import XCTest

extension XCTestCase {
	
	func expectation(description: String, timeout seconds: TimeInterval, handler: (@escaping () -> Void) -> Void) {
		let expectation = XCTestExpectation(description: description)
		handler({
			expectation.fulfill()
		})
		wait(for: [expectation], timeout: seconds)
	}
}
