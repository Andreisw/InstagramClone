//
//  ProfileCell.swift
//  Instagram
//
//  Created by Andrei Cojocaru on 03.08.2021.
//

import Foundation
import UIKit

class ProfileCell: UICollectionViewCell {
    
    
    //MARK: - Properties
    
    var viewModel: PostViewModel? {
        didSet{
            configure()
        }
    }
    
    private let postImageView: UIImageView = {
       let iv  = UIImageView()
        iv.image = #imageLiteral(resourceName: "venom-7")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    //MARK: - Lifecyle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        
        addSubview(postImageView)
        postImageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure() {
        guard let viewModel = viewModel else { return }
        postImageView.sd_setImage(with: viewModel.imageURL)
    }
}
