//
//  FeedController.swift
//  Instagram
//
//  Created by Andrei Cojocaru on 03.08.2021.
//

import Foundation
import Foundation
import UIKit
import Firebase

private let reuseIdentifier = "feedCell"

class FeedController : UICollectionViewController {
    
      var posts = [Post]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var post: Post?
    
  
    
    // MARK: - Actions
    
    @objc func handleLogOut() {
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
        catch {
            print("DEBUG: Failed to signed out")
        }
    }
    
    @objc func handleRefesh() {
        posts.removeAll()
//        refresher.endRefreshing()
        
        
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()
        
    }
    
    //   MARK: - API
    
    func fetchPosts() {
        guard post == nil else { return }

        PostService.fetchFeePosts { posts in
            self.posts = posts
            self.checkIfUserLikePost()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func checkIfUserLikePost() {
        self.posts.forEach { post in
            PostService.checkIfUserLikePost(post: post) { didLike in
                if let index = self.posts.firstIndex(where: { $0.postId == post.postId }) {
                    self.posts[index].didLike = didLike
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = .white
        collectionView.register(FeeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        if post == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(handleLogOut))
        }
        
        let refresher = UIRefreshControl()
        navigationItem.title = "Feed"
        
       
        refresher.addTarget(self, action: #selector(handleRefesh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
}



// MARK: UICOLLectionViewDataSoutce

extension FeedController {
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post  == nil ? posts.count : 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeeedCell
        cell.delegate = self
        
        if let post = post {
            cell.viewModel = PostViewModel(post: post)
            
        }else {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        return cell
    }
}


// MARK: -  UICollectionViewDelegateFlowLayout, Cell Height

extension FeedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        
        return CGSize(width: width, height: height)
    }
}

extension FeedController: FeedCellDelegate {
    
    func cell(_ cell: FeeedCell, wantsToShowProfileFor uid: String) {
        UserService.fetchUser(withUid: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func cellShowComments(_ cell: FeeedCell, wantsToShowCommentsFor post: Post) {
        let controller = CommentsController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(_ cell: FeeedCell, didLike post: Post) {
        guard let tab = self.tabBarController as? MainTabController else { return }
        guard let user = tab.user  else { return }
        
                cell.viewModel?.post.didLike.toggle()
        
        if post.didLike {
            PostService.unLikePost(post: post) { erorr in
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
            }
        }
        else {
            PostService.likePost(post: post) { error in
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .red
                cell.viewModel?.post.likes = post.likes + 1
                
                NotificationService.uploadNotification(toUid: post.ownerUID,
                                                       fromUser: user, type: .like,post: post)
            }
        }
    }
}
