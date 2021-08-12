//
//  User.swift
//  Instagram
//
//  Created by Andrei Cojocaru on 03.08.2021.
//

import Foundation
import Firebase


struct User {
    
    let email: String
    let fullname: String
    let profileImageUrl: String
    let userName : String
    let uid: String
    
    
    var isFollowed = false
    
    var stats: UserStats!
    
    var isCurrentUSer : Bool {return  Auth.auth().currentUser?.uid == uid }
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.userName = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        
        
        self.stats = UserStats(followers: 0, following: 0,posts: 0)
    }
}

struct UserStats {
    let followers: Int
    let following: Int
    let posts: Int
}
