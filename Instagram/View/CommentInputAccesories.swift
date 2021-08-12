//
//  CommentInputAccesories.swift
//  Instagram
//
//  Created by Andrei Cojocaru on 03.08.2021.
//

import Foundation
import UIKit

protocol CommentInputAccesoriesDelegate: AnyObject {

    func inputView( _ inputView: CommentInputAccesories, wantsToUploadComment comment: String)
}

class CommentInputAccesories: UIView {
    
    //MARK: - Propertiesw
    
    
    weak var delegate : CommentInputAccesoriesDelegate?
    
    private let commentTextView: InputTextView = {
       let tv = InputTextView()
        tv.placeHolderText = "Enter comment"
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.isScrollEnabled = false
        tv.placeHolderShouldCenter = true
        
        return tv
        
    }()
    
    private let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handlePostTapped), for: .touchUpInside)
        
        return button
        
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        addSubview(postButton)
        
        postButton.anchor(top:topAnchor,right:rightAnchor,paddingRight: 8)
        postButton.setDimensions(height: 50, width: 50)
        
        addSubview(commentTextView)
        commentTextView.anchor(top:topAnchor,left: leftAnchor,
                               bottom: safeAreaLayoutGuide.bottomAnchor,
                               right: postButton.leftAnchor,
                               paddingTop: 8,paddingLeft: 8,paddingBottom: 8,paddingRight: 8)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.anchor(top:topAnchor,left: leftAnchor,right: rightAnchor,height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
     //MARK: Actions
    }
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
        
        @objc func handlePostTapped() {
            delegate?.inputView(self, wantsToUploadComment: commentTextView.text)
        }
    
   // MARK: - HElPERS
    
    func clearCommentTextView() {
        commentTextView.text = nil
        commentTextView.placeHolderLabel.isHidden = false
        
    }
    }

