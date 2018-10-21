//
//  CollectionViewCells.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 10/20/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

class AssignmentCell: UICollectionViewCell {
    
    var picture: UIImage! {
        didSet {
            setImageView()
        }
    }
    
    var title: String! {
        didSet {
            setTitleView()
        }
    }
    
    var imageView: UIImageView!
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setBorder()
        
    }
    
    func setTitleView() {
        
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.addSubview(titleLabel)
        
    }
    
    func setBorder() {
        
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.retrieveMainColor(withAlpha: 1.0).cgColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 3
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageView() {
        
        imageView = UIImageView(image: picture)
        imageView.frame = CGRect(x: 10, y: 10, width: self.frame.width - 20, height: self.frame.height - 20)
        self.addSubview(imageView)
        
    }
    
}
