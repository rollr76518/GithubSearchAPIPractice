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
	
	private let viewModel = UsersViewModel()

	override func viewDidLoad() {
        super.viewDidLoad()
		
		viewModel.delegate = self
    }
}

extension UsersViewController: UISearchBarDelegate {
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText.isEmpty {
			viewModel.cleanSearch()
		} else {
			viewModel.getUsersByName(searchText)
		}
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
}

extension UsersViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.users.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageAndLabelCollectionViewCell", for: indexPath) as? ImageAndLabelCollectionViewCell else {
			return UICollectionViewCell()
		}
		let user = viewModel.users[indexPath.row]
		cell.label.text = user.login
		cell.imageView.imageFromURL(user.avatarUrl, placeholder: nil)
		return cell
	}
}

extension UsersViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if indexPath.row == viewModel.users.count - 1, let term = searchBar.text {
			viewModel.getNextPageByName(term)
		}
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

extension UsersViewController: UsersViewModelDelegate {
	
	func viewModel(_ viewModel: UsersViewModel, addUsersAt indexes: [Int]) {
		let indexPathes = indexes.map { IndexPath(row: $0, section: 0) }
		collectionView.insertItems(at: indexPathes)
	}
	
	func viewModelReloadUsers(_ viewModel: UsersViewModel) {
		collectionView.reloadData()
	}
	
	func viewModel(_ viewModel: UsersViewModel, showAlert text: String) {
		let alert = UIAlertController(title: "Prompt", message: text, preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .default, handler: nil)
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
}
