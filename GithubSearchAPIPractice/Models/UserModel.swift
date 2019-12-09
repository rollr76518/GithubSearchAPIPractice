//
//  UserModel.swift
//  GithubSearchAPIPractice
//
//  Created by Ryan on 2019/12/9.
//  Copyright © 2019 Hanyu. All rights reserved.
//

import Foundation

// TODO: URL 跟 ID 應該要大寫
struct User: Decodable, Hashable {
	
    let login: String
    let id: Int
    let nodeId: String
    let avatarUrl: URL
    let gravatarId: String
    let url: URL
    let htmlUrl: URL
    let followersUrl: URL
    let followingUrl: String
    let gistsUrl: String
    let starredUrl: String
    let subscriptionsUrl: URL
    let organizationsUrl: URL
    let reposUrl: URL
    let eventsUrl: String
    let receivedEventsUrl: URL
    let type: String
    let siteAdmin: Bool
    let score: Double
}
