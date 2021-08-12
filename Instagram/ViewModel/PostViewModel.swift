//
//  PostViewModel.swift
//  Instagram
//
//  Created by Andrei Cojocaru on 03.08.2021.
//

import Foundation
import UIKit

struct PostViewModel {
     var post: Post
    
    var imageURL: URL? {
        return URL(string: post.imageUrl)
    }
    var userProfileImageUrl: URL? {  return URL(string: post.ownerImageURl)}
    
    var username: String { return post.ownerUsername}
    
    var caption: String {
        return post.caption
    }
    var likes: Int { return post.likes }
    var likeButtonTintColor: UIColor {
        return post.didLike ? .red : .black
    }
    
    var likeButtonImage: UIImage? {
        
        let imageName = post.didLike ? "like_selected" : "like_unselected"
        return UIImage(named: imageName)
    }
    
    var likesLabelTextString: String {
        if post.likes != 1 {
            return "\(post.likes) likes"
        }else {
            return "\(post.likes) like"
        }
    }
    
    init(post: Post) {
        self.post = post
    }
}
