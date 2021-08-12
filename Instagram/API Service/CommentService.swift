//
//  CommentService.swift
//  Instagram
//
//  Created by Andrei Cojocaru on 04.08.2021.
//

import Foundation
import Firebase




struct CommentService {
    static func uploadComment(comment: String, postID: String,user:User, completion: @escaping(FirestoreCompletion)) {
        
        let data: [String:Any] = ["uid":user.uid,
                                  "commnet":comment,"timestamp":Timestamp(date: Date()),
                                  "username": user.userName,
                                  "profileImageUrl": user.profileImageUrl]
        COLLECTION_POSTS.document(postID).collection("comments").addDocument(data: data,completion: completion)
    }
    
    static func fetchComments(forPost postID: String, completion: @escaping([Comment]) -> Void) {
        var comments = [Comment]()
        
        let query = COLLECTION_POSTS.document(postID).collection("comments")
            .order(by: "timestamp",descending: true)
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    let comment = Comment(dictionary: data)
                    comments.append(comment)
                    
                }
            })
            completion(comments)
        }
    }
}
