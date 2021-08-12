//
//  Post.swift
//  Instagram
//
//  Created by Andrei Cojocaru on 03.08.2021.
//

import Foundation
import Firebase


struct Post {
    var caption: String
    var likes: Int
    let imageUrl: String
    let ownerUID: String
    let timestamp: Timestamp
    let postId: String
    let ownerImageURl: String
    let ownerUsername: String
    var didLike = false
    
    init(postId:String ,dictionary: [String: Any]) {
        self.postId = postId
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.ownerUID = dictionary["ownerUid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.ownerImageURl = dictionary["ownerImageURl"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
}
}

