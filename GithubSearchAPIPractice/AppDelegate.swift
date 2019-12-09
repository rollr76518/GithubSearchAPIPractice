//
//  AppDelegate.swift
//  GithubSearchAPIPractice
//
//  Created by Ryan on 2019/12/9.
//  Copyright © 2019 Hanyu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		appURLCacheSetup()
		
		return true
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		
		appURLCacheRemoved()
	}
}

extension AppDelegate {
	//TODO: 應該移到更適合的地方
	private func appURLCacheSetup() {
		// App URL Cache Setup
		let memory500MB = 500 * 1024 * 1024
		let cache = URLCache(memoryCapacity: memory500MB, diskCapacity: memory500MB, diskPath: nil)
		URLCache.shared = cache
	}
	
	private func appURLCacheRemoved() {
		URLCache.shared.removeAllCachedResponses()
	}
}
