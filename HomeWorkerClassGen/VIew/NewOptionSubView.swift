//
//  NewOptionSubView.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 10/28/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

class NewOptionSubView: UIView {
    
    var buttonString: String!
    var titleString: String!
    var centerHeight: CGFloat!
    
    var subViewAction: UIView!
    
    var topLabel: UILabel!
    var bottomButton: RoundedButtons!
    
    var parentViewController: NewOptionViewController!
    
    func figureHeight() -> CGFloat {
        
        return centerHeight + 105.00
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Do initialization stuff here
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 20
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func postionItems() {
        
        topLabel = UILabel()
        topLabel.text = titleString
        topLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 32)
        topLabel.font = UIFont.systemFont(ofSize: 20)
        topLabel.textAlignment = .center
        topLabel.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        self.addSubview(topLabel)
        
        bottomButton = RoundedButtons()
        bottomButton.borderRadius = 10
        bottomButton.setTitle(buttonString, for: .normal)
        bottomButton.setTitleColor(UIColor.retrieveMainColor(withAlpha: 1.0), for: .normal)
        bottomButton.borderColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        bottomButton.lineWidth = 2
        bottomButton.frame = CGRect(x: 20, y: self.frame.height - 50, width: self.frame.width - 40, height: 32)
        bottomButton.addTarget(self, action: #selector(showNextOption), for: .touchUpInside)
        self.addSubview(bottomButton)
        
        subViewAction.frame = CGRect(x: 20, y: 38, width: self.frame.width - 40, height: centerHeight)
        self.addSubview(subViewAction)
        
    }
    
    @objc func showNextOption() {
        
        parentViewController.showNextOption()
        
    }
    
    
}



