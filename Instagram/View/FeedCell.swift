//
//  FeedCell.swift
//  Instagram
//
//  Created by Andrei Cojocaru on 03.08.2021.
//

import Foundation
import UIKit
import YPImagePicker
import JGProgressHUD

protocol FeedCellDelegate: AnyObject {
    func cellShowComments(_ cell: FeeedCell, wantsToShowCommentsFor post: Post)
    func cell(_ cell: FeeedCell, didLike post: Post)
    func cell(_ cell: FeeedCell, wantsToShowProfileFor uid: String)
}

class FeeedCell: UICollectionViewCell {
    
    //MARK: Properties
    
    var viewModel : PostViewModel? {
        didSet {
            configure()
        }
    }
   weak var delegate : FeedCellDelegate?
    
   private lazy var  profileIamgeView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = .lightGray
    
    let tap = UIGestureRecognizer(target: self, action: #selector(showUserProfile))
    iv.isUserInteractionEnabled = true
    iv.addGestureRecognizer(tap)
        
        return iv
    }()
    
    private lazy var userNameButton : UIButton = {
        let button  = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
     
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(didTapUserName), for: .touchUpInside)
        
        return button
    }()
    
    private let posteImageView: UIImageView = {
        let pv = UIImageView()
        pv.contentMode = .scaleAspectFill
        pv.clipsToBounds = true
        pv.isUserInteractionEnabled = true
        pv.image = #imageLiteral(resourceName: "venom-7")
        
        return pv
    }()
    
     lazy var likeButton : UIButton = {
        let button  = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var commentButton : UIButton = {
        let button  = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapComments), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var shareButton : UIButton = {
        let button  = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        
        return label
    }()
    
    private let postTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "2 days ago"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .lightGray
        
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        
        
        return label
    }()
    
    //MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(profileIamgeView)
        profileIamgeView.anchor(top: topAnchor, left: leftAnchor,
                                paddingTop: 12, paddingLeft: 12)
        profileIamgeView.setDimensions(height: 40, width: 40)
        profileIamgeView.layer.cornerRadius = 40 / 2
        
        addSubview(userNameButton)
        userNameButton.centerY(inView: profileIamgeView,
                               leftAnchor: profileIamgeView.rightAnchor, paddingLeft: 8)
        
        addSubview(posteImageView)
        posteImageView.anchor(top: profileIamgeView.bottomAnchor, left: leftAnchor, right: rightAnchor,
                              paddingTop: 8)
        posteImageView.heightAnchor.constraint(equalTo: widthAnchor,multiplier: 1).isActive = true
        configureActionButtons()
        
        addSubview(likesLabel)
        likesLabel.anchor(top:likeButton.bottomAnchor,
                          left: leftAnchor,paddingTop: -4,paddingLeft: 8)
        
        addSubview(captionLabel)
        captionLabel.anchor(top:likesLabel.bottomAnchor, left: leftAnchor,paddingTop: 8,paddingLeft: 8)
        
        addSubview(postTimeLabel)
        postTimeLabel.anchor(top:captionLabel.bottomAnchor, left: leftAnchor,paddingTop: 8,paddingLeft: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func showUserProfile() {
        guard let viewModel = viewModel  else {return}
        delegate?.cellShowComments(self, wantsToShowCommentsFor: viewModel.post)
    }
    
    @objc func didTapComments() {
        
        guard let viewModel = viewModel  else {return}
        delegate?.cellShowComments(self, wantsToShowCommentsFor: viewModel.post)
    }
    
    @objc func didTapUserName() {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, wantsToShowProfileFor: viewModel.post.ownerUID)
}
    
    @objc func didTapLike() {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, didLike: viewModel.post)
        
    }
    //MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        captionLabel.text = viewModel.caption
        posteImageView.sd_setImage(with: viewModel.imageURL)
        profileIamgeView.sd_setImage(with: viewModel.userProfileImageUrl)
        userNameButton.setTitle(viewModel.username, for: .normal)
        likesLabel.text = viewModel.likesLabelTextString
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
    }
    
    
    func configureActionButtons() {
      let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,shareButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.anchor(top: posteImageView.bottomAnchor, width: 120, height: 50)
    }
    
}
