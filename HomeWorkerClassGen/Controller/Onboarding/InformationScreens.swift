//
//  InformationScreens.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 9/27/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

class OnboardingScreens: UIViewController {
    
    @IBOutlet weak var slantedView: SlantedView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var majorTextView: UITextView!
    @IBOutlet weak var nextButton: RoundedButtons!
    
    override func viewDidLoad() {
        //change everything to be in the right spot
        
        slantedView.frame = CGRect(x: 0, y: 0 - (self.view.frame.height - 264), width: self.view.frame.width, height: self.view.frame.height - 40)
        titleLabel.frame = CGRect(x: 8, y: 12, width: self.view.frame.width - 16, height: 250)
        majorTextView.frame = CGRect(x: 8, y: 276, width: self.view.frame.width - 16, height: 309)
        nextButton.frame = CGRect(x: self.view.frame.width / 2 - 77.5, y: self.view.frame.height - 78, width: 155, height: 66)
        
        nextButton.addTarget(self, action: #selector(animateToNext), for: .touchUpInside)
        
    }
    
    @objc func animateToNext() {
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1.0, options: [], animations: {
            self.slantedView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 40)
        }, completion: nil)
    }
    
}
