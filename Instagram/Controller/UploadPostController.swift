//
//  UploadPostController.swift
//  Instagram
//
//  Created by Andrei Cojocaru on 03.08.2021.
//

import Foundation
import UIKit

protocol UploadPostControllerDelegate: AnyObject {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
}

class UploadPostController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: UploadPostControllerDelegate?
    
    var currentUser: User?
    
    var selectedImage : UIImage? {
        didSet {photoImageView.image = selectedImage}
    }
    
    private let photoImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    private lazy var captionTextView: InputTextView = {
        let caption = InputTextView()
        caption.placeHolderText = "Enter caption"
        caption.font = UIFont.systemFont(ofSize: 16)
        caption.delegate = self
        caption.placeHolderShouldCenter = false
        
        return caption
    }()
    
    private  let characterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/100"
        
        return label
        
    }()
    
    //MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configurUI()
    }
    
    //MARK: - Actions
    
    @objc func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapDone() {
        guard let image = selectedImage else { return }
        guard let caption = captionTextView.text else { return }
        guard let user = currentUser else { return }


        showLoader(true)
        
        PostService.uploadPOst(caption: caption, image: image,user: user) { error in
            self.showLoader(false)
            if let error = error {
                print("DEBUG Failed to upload image with \(error.localizedDescription)")
                return
            }
            self.delegate?.controllerDidFinishUploadingPost(self)
    }
    }
  //  MARK: - Helpers
    
    
    func checkMaxLenght( _ textView:UITextView, maxLenght: Int) {
        if(textView.text.count) > maxLenght {
            textView.deleteBackward()
        }
    }
    
    func configurUI() {
        
        navigationItem.title = "Upload post"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(didTapDone))
        
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: 180, width: 180)
        photoImageView.anchor(top:view.safeAreaLayoutGuide.topAnchor,paddingTop: 8)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top:photoImageView.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,
                               paddingTop: 16,paddingLeft: 12,paddingRight: 12,height: 64)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(top: captionTextView.bottomAnchor,right: view.rightAnchor,
                                   paddingBottom: -8,paddingRight: 12)
    }
}

// MARK: UItetxfield Delegate

extension UploadPostController:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLenght(textView, maxLenght: 100)
    }
}
