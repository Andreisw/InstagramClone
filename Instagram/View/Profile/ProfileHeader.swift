//
//  ProfileHeader.swift
//  Instagram
//
//  Created by Andrei Cojocaru on 03.08.2021.
//

import Foundation
import  UIKit
import  SDWebImage

protocol ProfileHeaderDelegate: AnyObject {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User)
    
}


class ProfileHeader: UICollectionReusableView {
    
    
    //MARK: - Properties
    
    var viewModel: ProfileHeaderViewModel? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    private let profileImageVIew: UIImageView = {
       let iv  = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    private let nameLabel : UILabel = {
       let label = UILabel()
        
        
        
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
        
    }()
    
    private lazy var editPRofileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleDeitProfileFollowTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var postLabel :  UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
    
        
        return label
    }()
    
    private lazy var followersLabel :  UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
       
        
        return label
    }()
    
    private lazy  var followingLabel :  UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
     
        
        return label
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
        
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        
        return button
        
    }()
    
    let bookMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        
        return button
        
    }()
    
    //MARK: - Lifecyle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(profileImageVIew)
        profileImageVIew.anchor(top:topAnchor,left: leftAnchor,paddingTop: 16,paddingLeft: 12)
        profileImageVIew.setDimensions(height: 80, width: 80)
        profileImageVIew.layer.cornerRadius = 80 / 2
        
        addSubview(nameLabel)
        nameLabel.anchor(top:profileImageVIew.bottomAnchor,left: leftAnchor,paddingTop: 12,paddingLeft: 12)
        
        addSubview(editPRofileFollowButton)
        editPRofileFollowButton.anchor(top:nameLabel.bottomAnchor,left: leftAnchor,right: rightAnchor,
                                       paddingTop: 16,paddingLeft: 24,paddingRight: 24)
        
        let stack = UIStackView(arrangedSubviews: [postLabel,followersLabel,followingLabel])
        stack.distribution = .fillEqually
    
        addSubview(stack)
        stack.centerY(inView: profileImageVIew)
        stack.anchor(left:profileImageVIew.rightAnchor,right: rightAnchor,paddingLeft: 12,paddingRight: 12,height: 50)
        
        let topDivider  =  UIView()
        topDivider.backgroundColor = .lightGray
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .lightGray

        let buttonStack = UIStackView(arrangedSubviews: [gridButton,listButton,bookMarkButton])
        buttonStack.distribution = .fillEqually
        
        
        addSubview(buttonStack)
        addSubview(topDivider)
        addSubview(bottomDivider)
        
        buttonStack.anchor(left:leftAnchor, bottom: bottomAnchor, right: rightAnchor,height: 50)
        topDivider.anchor(top: buttonStack.topAnchor, left: leftAnchor,right: rightAnchor,height: 0.5)
        bottomDivider.anchor(top: buttonStack.bottomAnchor, left: leftAnchor,right: rightAnchor,height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleDeitProfileFollowTapped() {
        
        guard  let viewModel = viewModel else { return }
        delegate?.header(self, didTapActionButtonFor: viewModel.user)
    }
    
    //MARK: -  Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        nameLabel.text = viewModel.fullname
        profileImageVIew.sd_setImage(with: viewModel.profileImageUrl)
        
        editPRofileFollowButton.setTitle(viewModel.followedButtonText, for: .normal)
        editPRofileFollowButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
        editPRofileFollowButton.backgroundColor = viewModel.followButtonBackgroundColor
        
        postLabel.attributedText = viewModel.numberOfPosts
        followersLabel.attributedText = viewModel.numberOfFollowers
        followingLabel.attributedText = viewModel.numberOfFollowing
    }
}
