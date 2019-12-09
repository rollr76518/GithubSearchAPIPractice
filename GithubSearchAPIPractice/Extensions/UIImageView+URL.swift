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
		
		URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
			if let _ = error {
				//TODO: handle error
				return
			}
			
			if let data = data {
				let image = UIImage(data: data)
				DispatchQueue.main.async {
					self.image = image
				}
			}
		}).resume()
	}
}
