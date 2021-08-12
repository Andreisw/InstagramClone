//
//  MainTabController.swift
//  Instagram
//
//  Created by Andrei Cojocaru on 03.08.2021.
//

import Foundation

import UIKit
import Firebase
import YPImagePicker

class MainTabController: UITabBarController {

    
    // MARK: - Lifecycle
    
     var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewControllers(withUser: user)}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedin()
        fethUser()
    }
    
    // MARK: - API
    
    func fethUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchUser(withUid: uid) { user in
            self.user = user
        }
        }
    
    
    func checkIfUserIsLoggedin() {
        
        if Auth.auth().currentUser == nil {
            
            DispatchQueue.main.async {
            let controller = LoginController()
                controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
                
                
            }
        }
    }
    
    // MARK: - Helpers
    
    func configureViewControllers(withUser user: User) {
        view.backgroundColor = .white
        self.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        let feed = templateNAvigationController(unselctedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedController(collectionViewLayout: layout))
        let search = templateNAvigationController(unselctedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchController())
        let imageSelector = templateNAvigationController(unselctedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: ImageSelectorController())
        let notification = templateNAvigationController(unselctedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationController())
        
        let profileController = ProfileController(user: user)
        let profile = templateNAvigationController(unselctedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: profileController)
        
        viewControllers = [feed,search,imageSelector,notification,profile]
        
        tabBar.tintColor = .black
    }
    
    func templateNAvigationController(unselctedImage:UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselctedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        
        return nav
    }
    
    func didFinishPickingMedia( _ picker: YPImagePicker) {
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated:true) {
                guard let selectedImage = items.singlePhoto?.image else {return}
    
                let controller = UploadPostController()
                controller.selectedImage = selectedImage
                controller.delegate = self
                controller.currentUser = self.user
                
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
}


extension MainTabController: AutheticationDelegate {
    func autheticationDidComplete() {
        fethUser()
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK: - UITabBarControllerDelegate

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
            
            didFinishPickingMedia(picker)
        }
        
        
        return true
    }
}

//MARK: - Upload Post Controller Delegate

extension MainTabController: UploadPostControllerDelegate {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
       selectedIndex = 0
        controller.dismiss(animated: true, completion: nil)
        guard let feedNav = viewControllers?.first as? UINavigationController  else { return }
        guard let feed = feedNav.viewControllers.first as? FeedController  else { return}
        feed.handleRefesh()
        
    }
}
