//
//  UsersViewController.swift
//  GithubSearchAPIPractice
//
//  Created by Ryan on 2019/12/10.
//  Copyright © 2019 Hanyu. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {
	
	@IBOutlet weak var searchBar: UISearchBar!
	
	@IBOutlet weak var collectionView: UICollectionView! {
		didSet {
			collectionView.register(UINib(nibName: "ImageAndLabelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageAndLabelCollectionViewCell")
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension UsersViewController: UISearchBarDelegate {
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText != "" {

		} else {
			
		}
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
}

extension UsersViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 100
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageAndLabelCollectionViewCell", for: indexPath) as? ImageAndLabelCollectionViewCell else {
			return UICollectionViewCell()
		}
		cell.label.text = "\(indexPath)"
		return cell
	}
}

extension UsersViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let numberOfItemPerRow: CGFloat = 3
		let spaces = numberOfItemPerRow - 1
		let width = (collectionView.frame.width - spaces) / numberOfItemPerRow
		let height = width * 1.3
		return CGSize(width: width, height: height)
	}
}

