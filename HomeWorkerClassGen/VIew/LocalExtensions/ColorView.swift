//
//  ColorView.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 10/16/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

//let newColorView = UIView(frame: CGRect(x: 15, y: (topSpace + (spacePerColor * currentColor)), width: 42, height: 42))
//
//newColorView.backgroundColor = color
//newColorView.layer.borderColor = UIColor.white.cgColor
//newColorView.layer.borderWidth = 3
//newColorView.layer.cornerRadius = 21
//
//self.view.addSubview(newColorView)

class ColorView: UIView {
    
    init(frame: CGRect, color: Colors, selected: Bool) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.getColor(color)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 3
        self.layer.cornerRadius = 21
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
