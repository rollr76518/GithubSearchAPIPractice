//
//  UIImageView+URL.swift
//  GithubSearchAPIPractice
//
//  Created by Ryan on 2019/12/10.
//  Copyright © 2019 Hanyu. All rights reserved.
//

import UIKit.UIImageView

extension UIImageView {
	
	func imageFromURL(_ url: URL, placeholder: UIImage?) {
		self.image = placeholder
		
		let request = URLRequest(url: url)
		
		if let cache = URLCache.shared.cachedResponse(for: request) {
			let image = UIImage(data: cache.data)
			DispatchQueue.main.async {
				self.image = image
			}
		} else {
			URLSession.shared.dataTask(with: request) { (data, response, error) in
				if let _ = error {
					//TODO: handle error
					return
				}
				
				if let data = data, let response = response {
					let image = UIImage(data: data)
					DispatchQueue.main.async {
						self.image = image
					}
					let cachedData = CachedURLResponse(response: response, data: data)
					URLCache.shared.storeCachedResponse(cachedData, for: request)
				}
			}.resume()
		}
	}
}
