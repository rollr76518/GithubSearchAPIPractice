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



	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		appURLCacheSetup()
		
		return true
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		
		appURLCacheRemoved()
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
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
