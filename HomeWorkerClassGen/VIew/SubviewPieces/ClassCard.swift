//
//  ClassCard.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 11/23/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

class ClassCard: UIView {
    
    var myClass: Classes!
    
    let bottomView = UIView()
    
    init(frame: CGRect, _ thisClass: Classes) {
        super.init(frame: frame)
        
        self.myClass = thisClass
        
        setLooks()
        makeBottom()
        
    }
    
    func setLooks() {
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.blue
    }
    
    func makeBottom() {
        bottomView.frame = CGRect(x: 0, y: self.frame.height / 2, width: self.frame.width, height: self.frame.height / 2)
        bottomView.backgroundColor = UIColor.black
        self.addSubview(bottomView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
