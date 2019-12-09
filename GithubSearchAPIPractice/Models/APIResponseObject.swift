//
//  APIResponseObject.swift
//  GithubSearchAPIPractice
//
//  Created by Ryan on 2019/12/9.
//  Copyright © 2019 Hanyu. All rights reserved.
//

import Foundation

struct APIResponseObject<item: Decodable>: Decodable {
	
	let totalCount: Int
	let incompleteResults: Bool
	let items: [item]
}
