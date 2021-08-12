//
//  ImageUploader.swift
//  Instagram
//
//  Created by Andrei Cojocaru on 03.08.2021.
//

import Foundation

import FirebaseStorage

struct ImageUploader {
    
    
    static func uploadImage(image:UIImage,completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 075) else {return}
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        ref.putData(imageData, metadata: nil) { metadata, error in
            
            if let error  = error {
                print("Debug upload image faile \(error.localizedDescription)")
                return
            }
            ref.downloadURL { (url, error) in
                
                guard let imageURL = url?.absoluteString else {return}
                completion(imageURL)
            }
        }
    }
}

