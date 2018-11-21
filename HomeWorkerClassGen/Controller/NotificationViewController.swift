//
//  NotificationViewController.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 11/21/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

class NotificationPage: UIViewController {
    
    override func viewDidLoad() {
        print("In the notification page!!!!")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.purple
        sleep(3)
        self.present(WorkView(), animated: true, completion: nil)
    }
    
}
