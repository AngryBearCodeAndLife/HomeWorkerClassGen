//
//  SaveLocal.swift
//  HomeWorker
//
//  Created by Ryan Topham on 8/12/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Disk
import SwiftKeychainWrapper

//NOTE: SHOULD SAVE EVERYTHHING TO .CACHES AS I CAN ALWAYS GET IT BACK FROM THE CLOUD

struct LocalActions {
    
    struct ProfileImage {
        //Saving the profile image
        static func save(image: UIImage) {
            
            do {
                try Disk.save(image, to: .caches, as: "profilePicture.jpg")
            } catch {
                //Should do something else here
            }
            
        }
        
        //Fetching the profile image
        static func fetch() -> UIImage {
            
            do {
                let image = try Disk.retrieve("profilePicture.jpg", from: .caches, as: UIImage.self)
                return image
            } catch {
                return UIImage()
            }
            
        }
        
        //Delete the profile image
        static func delete() {
            if Disk.exists("profilePicture.jpeg", in: .caches) {
                do {
                    try Disk.remove("profilePicture.jpeg", from: .caches)
                } catch {
                    //Should do something here
                }
            } else {
                //should do something here
            }
        }
        
    }
    
    //Everything to do with the work images
    struct WorkImages {
        
        //Save a single image if given the image and the id
        static func save(id: String, image: UIImage) {
            let imageURL = "work/images/\(id).jpg"
            do {
                try Disk.save(image, to: .caches, as: imageURL)
            } catch {
                //Should do somethikng here
            }
        }
        
        //Fetch a single images from an id
        static func fetch(id: String) -> UIImage {
            
            let imageURL = "work/images/\(id).jpg"
            do {
                let workImage = try Disk.retrieve(imageURL, from: .caches, as: UIImage.self)
                return workImage
            } catch {
                return UIImage()
            }
            
        }
        
        //Actions for all of the images
        struct All {
            //Get the images from storage in an array of images
            static func fetch() -> [UIImage] {
                let imageURL = "work/images"
                var imageArray: [UIImage] = []
                do {
                    imageArray = try Disk.retrieve(imageURL, from: .caches, as: [UIImage].self)
                } catch {
                    //Should do something here
                }
                return imageArray
            }
            
            //Get the number of images in the local storage
            static func count() -> Int {
                let arrayOfWorkImages = self.fetch()
                return arrayOfWorkImages.count
            }
            
            static func delete() {
                if Disk.exists("work/images", in: .caches) {
                    do {
                        try Disk.remove("work/images", from: .caches)
                    } catch {
                        //Should do something here
                    }
                } else {
                    //Should do something
                }
            }
        }
        
    }
    
    //Everything to do with auto loggin
    struct AutoLoggin {
        static func isEnabled() -> Bool {
            return UserDefaults.standard.bool(forKey: "hasAutoSignIn")
        }
        
        static func password() -> String {
            
            if self.isEnabled() {
                return KeychainWrapper.standard.string(forKey: "userPassword")!
            } else {
                return ""
            }
            
        }
        
        static func username() -> String {
            
            if self.isEnabled() {
                return KeychainWrapper.standard.string(forKey: "userEmail")!
            } else {
                return ""
            }
            
        }
        
        static func enable(email: String, password: String, completion: (Bool) -> Void) {
            UserDefaults.standard.set(true, forKey: "hasAutoSignIn")
            let psaveSuccessful: Bool = KeychainWrapper.standard.set(email, forKey: "userPassword")
            let eSaveSuccessful: Bool = KeychainWrapper.standard.set(password, forKey: "userEmail")
            if psaveSuccessful && eSaveSuccessful {
                completion(true)
            } else {
                completion(false)
            }
        }
        
        static func disable(completion: (Bool) -> Void) {
            UserDefaults.standard.set(false, forKey: "hasAutoSignIn")
            let psaveSuccessful: Bool = KeychainWrapper.standard.set(String(), forKey: "userPassword")
            let eSaveSuccessful: Bool = KeychainWrapper.standard.set(String(), forKey: "userEmail")
            if psaveSuccessful && eSaveSuccessful {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    //WORK ARRAY STUFF==============================================================================================================
    
    struct WorkObjects {
        
        static func save(newWork: HomeWork) {
            
            var workArray: [HomeWork]!
            
            if Disk.exists("work.json", in: .caches) {
                //Then there is a file to retrieve
                do {
                    workArray = try Disk.retrieve("work.json", from: .caches, as: [HomeWork].self)
                    try Disk.remove("work.json", from: .caches)
                } catch {
                    workArray = []
                }
            } else {
                //Just add it to an empty array
                workArray = []
            }
            
            workArray.append(newWork)
            try! Disk.save(workArray, to: .caches, as: "work.json")
        }
        
        static func fetch(id: String) -> HomeWork {
            let workArray = self.All.fetch()
            var workToReturn: HomeWork!
            for work in workArray {
                if work.uid == id {
                    workToReturn = work
                }
            }
            if workToReturn == nil {
                workToReturn = HomeWork("make an assignment", "HomeWorker", false, Date.init(), "randidthatdoesntmatter")
            }
            return workToReturn
        }
        
        static func delete(id: String) {
            let workArray = self.All.fetch()
            var saveArray: [HomeWork]! = workArray
            var madeChange = false
            for (index, work) in workArray.enumerated() {
                if work.uid == id {
                    saveArray.remove(at: index)
                    madeChange = true
                }
            }
            if madeChange {
                //Get rid of the old array
                self.All.delete()
                //Resave the array that we have
                self.All.save(workArray: saveArray)
            }
        }
        
        struct All {
            static func save(workArray: [HomeWork]) {
                for oneWork in workArray {
                    LocalActions.WorkObjects.save(newWork: oneWork)
                }
            }
            
            static func fetch() -> [HomeWork] {
                var attempt: [HomeWork]! = []
                if Disk.exists("work.json", in: .caches) {
                    //Then there is a file to retrieve
                    do {
                        attempt = try Disk.retrieve("work.json", from: .caches, as: [HomeWork].self)
                        
                    } catch {
                        attempt = [HomeWork("make an assignment", "HomeWorker", false, Date.init(), "randidthatdoesntmatter")]
                    }
                }
                
                return attempt
                
            }
            
            static func delete() {
                //Use this in the case that we are signing in a nw user, and want to be able to just clear what the old user had, as they have no need for it
                if Disk.exists("work.json", in: .caches) {
                    do {
                        try Disk.remove("work.json", from: .caches)
                    } catch {
                    }
                } else {
                }
            }
        }
    }
    
    //THIS IS ALL OF THE WORK WITH THE NAME
    struct Name {
        //Save the name into local storage
        static func save(name: String) {
            UserDefaults.standard.set(name, forKey: "Username")
        }
        //Get the users name out of the local storage
        static func fetch() -> String {
            return UserDefaults.standard.string(forKey: "Username")!
        }
        //Remove the name from local storage.
        static func delete() {
            UserDefaults.standard.set("nil", forKey: "Username")
        }
    }
    
}
