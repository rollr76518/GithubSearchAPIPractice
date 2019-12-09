//
//  UsersViewModel.swift
//  GithubSearchAPIPractice
//
//  Created by Ryan on 2019/12/10.
//  Copyright © 2019 Hanyu. All rights reserved.
//

import Foundation

protocol UsersViewModelDelegate {
	
	func viewModel(_ viewModel: UsersViewModel, addUsersAt indexes: [Int])
	func viewModelReloadUsers(_ viewModel: UsersViewModel)
	func viewModel(_ viewModel: UsersViewModel, showAlert text: String)
}

private enum UsersChangedBehavior {
	case add([Int])
	case reload
}

class UsersViewModel {
	
	var delegate: UsersViewModelDelegate?
	
	private var previousTerm: String?
	private var nextPage: Int?
	
	private(set) var users: [User] = [] {
		didSet {
			let behavior = diff(original: oldValue, now: users)
			DispatchQueue.main.async {
				switch behavior {
				case .add(let indexes):
					self.delegate?.viewModel(self, addUsersAt: indexes)
				case .reload:
					self.delegate?.viewModelReloadUsers(self)
				}
			}
		}
	}
}

// Public method
extension UsersViewModel {
	
	func getUsersByName(_ name: String) {
		users(userName: name, page: nil)
	}
	
	func getNextPageByName(_ name: String) {
		//TODO: 阻擋已經打過的 API 再打出去
		guard let nextPage = nextPage, previousTerm == name else {
			return
		}
		users(userName: name, page: nextPage)
	}
	
	func cleanSearch() {
		previousTerm = nil
		nextPage = nil
		users = []
	}
}

private extension UsersViewModel {
	
	func diff(original: [User], now: [User]) -> UsersChangedBehavior {
        let originalSet = Set(original)
        let nowSet = Set(now)
        
        if originalSet.isSubset(of: nowSet) {
            let added = nowSet.subtracting(originalSet)
			let indexes = added.compactMap { now.firstIndex(of: $0) }
            return .add(indexes)
        } else {
            return .reload
        }
    }
	
	func users(userName: String, page: Int?) {
		// TODO: 應該要做 delay API request
		DataManager.shared.users(userName: userName, page: page) { [weak self] (result) in
			guard let self = self else { return }
			switch result {
			case .success(let (users, nextPage)):
				if self.previousTerm == userName {
					self.users += users
				} else {
					self.users = users
				}
				self.previousTerm = userName
				self.nextPage = nextPage
			case .failure(let error):
				DispatchQueue.main.async {
					self.delegate?.viewModel(self, showAlert: error.localizedDescription)
				}
			}
		}
	}
}
