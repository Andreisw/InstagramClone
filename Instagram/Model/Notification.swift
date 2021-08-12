//
//  Notification.swift
//  Instagram
//
//  Created by Andrei Cojocaru on 09.08.2021.
//

import Foundation
import Firebase

enum  NotificationType: Int {
    case like
    case follow
    case comment
    

    
    var notificationMessage: String {
        switch self {
        case .like:
            return "like yopur post"
        case .follow:
            return "follow yopur post"
        case .comment:
            return "comment yopur post"
        default:
            return "DEbug; Error swicht NotificationType"
        }
    }
}

struct Notification {
   let uid  : String
   let postImageUrl: String?
   let postId: String?
   var timestamp : Timestamp
   var type: NotificationType
   let id : String
   let userProfileImageUrl: String
   let username: String
   var userIsFollowed = false

    
    init(dictionary: [String: Any]) {
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.id = dictionary["id"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.postId = dictionary["postId"] as? String ?? ""
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
        self.userProfileImageUrl = dictionary["userProfileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
    }
}
