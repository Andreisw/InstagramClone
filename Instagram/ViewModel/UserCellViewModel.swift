//
//  UserCellViewModel.swift
//  Instagram
//
//  Created by Andrei Cojocaru on 03.08.2021.
//

import Foundation

struct UserCellViewModel {
    private let user: User
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    var username: String {
        return user.userName
    }
    var fullname: String {
        return user.fullname
    }
    
    init(user: User) {
        self.user = user
    }
}
