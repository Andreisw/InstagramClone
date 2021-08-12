//
//  InputeTextView.swift
//  Instagram
//
//  Created by Andrei Cojocaru on 03.08.2021.
//

import Foundation
import UIKit

class InputTextView: UITextView {
    
    //MARK: - Properties
    
    var placeHolderText: String? {
        
        didSet{ placeHolderLabel.text = placeHolderText}
        
    }
    
     var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    var placeHolderShouldCenter = true {
        didSet {
            if placeHolderShouldCenter {
                placeHolderLabel.anchor(left:leftAnchor,right: rightAnchor,paddingLeft: 8)
                placeHolderLabel.centerY(inView: self)
            }else {
                placeHolderLabel.anchor(top:topAnchor,left: leftAnchor,paddingTop: 6,paddingLeft: 8)
            }
        }
    }
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeHolderLabel)
        placeHolderLabel.anchor(top:topAnchor,left: leftAnchor,paddingTop: 6,paddingLeft: 8)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    //MARK: - Actions
    
    @objc func handleTextDidChange() {
        placeHolderLabel.isHidden = !text.isEmpty
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
