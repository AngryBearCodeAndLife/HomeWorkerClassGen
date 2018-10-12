//
//  AuthActions.swift
//  HomeWorker
//
//  Created by Ryan Topham on 8/12/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import SwiftKeychainWrapper

struct AuthActions {
    //
    //    static func turnToJPEG(image: UIImage) ->  {
    //        return image.jpegData(compressionQuality: 0.75)
    //    }
    
    static func createUser(name: String, email: String, password: String, profileImage: UIImage) -> Bool {
        var problem = false
        Auth.auth().createUser(withEmail: email, password: password, completion: { (authResult, error) in
            if error != nil {
                problem = true
                print("There is a problem, eventually do something to tell the other view contrller that it needs to tell the user why it just crashed")
            } else {
                FirebaseActions.Name.save(name: name)
                FirebaseActions.ProfileImage.save(profilePhoto: profileImage)
            }
        })
        return !problem
    }
    
    static func setUser() {
        
        //This will be called when a user is created, or when they log in. This is also called by the app delegate if it needs to autolog them in
        
        FirebaseActions.ProfileImage.fetch()
        FirebaseActions.Name.fetch()
        FirebaseActions.WorkObjects.fetch { (workArray) in
            LocalActions.WorkObjects.All.save(workArray: workArray)
        }
        
    }
    
    static func removeUser() {
        
        LocalActions.WorkImages.All.delete()
        LocalActions.WorkObjects.All.delete()
        LocalActions.ProfileImage.delete()
        LocalActions.Name.delete()
        
    }
    
    static func userSigningOut() -> Bool {
        var success = true
        LocalActions.ProfileImage.delete()
        LocalActions.WorkImages.All.delete()
        LocalActions.WorkObjects.All.delete()
        LocalActions.Name.delete()
        UserDefaults.standard.set(false, forKey: "hasAutoSignIn")
        let pRemove = KeychainWrapper.standard.removeObject(forKey: "userPassword")
        let eRemove = KeychainWrapper.standard.removeObject(forKey: "userEmail")
        if !eRemove || !pRemove {
            success = false
        }
        return success
    }
}
