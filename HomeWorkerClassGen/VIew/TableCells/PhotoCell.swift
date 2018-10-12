//
//  PhotoCell.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 10/9/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

class PhotoCell: UITableViewCell {
    
    var hasOtherWork: Bool! {
        didSet {
            setPhotoAndTitle()
        }
    }
    
    var photo = UIImageView()
    var title = UILabel()
    
    let workToGoSlogans = ["We Should Work On This...", "Still Got Stuff To Do", "You Can Do This", "Come On, Let's Get To Work"]
    let workToGoPictures = [UIImage(named: "getWorkDone"), UIImage(named: "getWorkDone2"), UIImage(named: "getWorkDone3")]
    
    let workDoneSlogans = ["YEEAAAHHHH!!!", "Nice Job!", "Keep Up The Awesomeness!", "Let's Do Something New!"]
    let workDonePictures = [UIImage(named: "workDone"), UIImage(named: "workDone2"), UIImage(named: "workDone3")]
    
    func setPhotoAndTitle() {
        
        //Give the basic things
        if hasOtherWork == true {
            //We need to show the photo that says to get things done
            photo.image = workToGoPictures.randomElement()!
            photo.layer.cornerRadius = 15
            self.addSubview(photo)
            photo.frame = CGRect(x: 40, y: 60, width: self.frame.width - 80, height: self.frame.height - 150)
            
            title.text = workToGoSlogans.randomElement()
            title.textAlignment = .center
            title.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
            title.frame = CGRect(x: 0, y: 100 + self.photo.frame.height, width: self.frame.width, height: 30)
            self.addSubview(title)
        } else {
            //We need to show the photo that says to get things done
            photo.image = workDonePictures.randomElement()!
            photo.layer.cornerRadius = 15
            self.addSubview(photo)
            photo.frame = CGRect(x: 40, y: 60, width: self.frame.width - 80, height: self.frame.height - 150)
            
            title.text = workDoneSlogans.randomElement()
            title.textAlignment = .center
            title.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
            title.frame = CGRect(x: 0, y: 100 + self.photo.frame.height, width: self.frame.width, height: 30)
            self.addSubview(title)
        }
        
    }
    
}
