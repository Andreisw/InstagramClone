//
//  ProfileHeaderViewModel.swift
//  Instagram
//
//  Created by Andrei Cojocaru on 03.08.2021.
//

import Foundation
import UIKit


struct ProfileHeaderViewModel {
    let user: User
    
    var fullname: String {
        return user.fullname
    }
    var profileImageUrl : URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var followedButtonText : String {
        if user.isCurrentUSer {
            return " Edit profile"
        }
        
        return user.isFollowed ? "Following" :  "Follow"
    }
    
    var followButtonBackgroundColor: UIColor {
        return user.isCurrentUSer ? .white : .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return user.isCurrentUSer ? .black : .white
    }
    
    var numberOfFollowers:NSAttributedString {
       return attributedStartText(value: user.stats.followers, label: "followers")
    }
    
    var numberOfFollowing: NSAttributedString{
        return attributedStartText(value: user.stats.following, label: "following")
    }
    
    var numberOfPosts: NSAttributedString {
        return attributedStartText(value: user.stats.posts, label: "posts")
    }
    
    init(user: User) {
        self.user = user
    }
    
    func attributedStartText(value:Int, label: String) -> NSAttributedString {
        let attributedText =  NSMutableAttributedString(string: "\(value)\n", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.lightGray]))
        
        return attributedText
    }
}
