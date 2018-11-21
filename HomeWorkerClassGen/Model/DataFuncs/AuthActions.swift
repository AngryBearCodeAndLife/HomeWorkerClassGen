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
import FirebaseDatabase

struct AuthActions {
    
    static func closeApp() {
        try? Auth.auth().signOut()
    }
    
    static func createNewUser(name: String, email: String, password: String, profileImage: UIImage, completion: @escaping (Bool) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            if error == nil && authResult != nil {
                
                DataStorage.AutoLoggin.enable(email: email, password: password)
                
                DataStorage.User.Name.save(name, completion: { success in
                    if success {
                        DataStorage.User.ProfileImage.save(profileImage, completion: { success in
                            if success {
                                completion(true)
                            } else {
                                completion(false)
                            }
                        })
                    } else {
                        completion(false)
                    }
                })
            } else {
                completion(false)
            }
            
        }
        
    }
    
    static func openApp(completion: @escaping (Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: DataStorage.AutoLoggin.email(), password: DataStorage.AutoLoggin.password()) { (authResult, error) in
            if error == nil && authResult != nil {
                
                if let myUID = Auth.auth().currentUser?.uid {
                    let changePath = "users/\(myUID)/updated"
                    let changeRef = Database.database().reference().child(changePath)
                    changeRef.observeSingleEvent(of: .value, with: { snapshot in
                        
                        let wasChanged = snapshot.value! as? Bool
                        
                        if wasChanged! {
                            DataStorage.WorkObjects.fetch(completion: { works in
                                print("All of the works that were found in the cloud while signing in", works)
                                DataStorage.WorkObjects.Local.save(works)
                                
                                changeRef.setValue(false)
                                DataStorage.ClassStorage.pullFromCloud()
                                completion(true)
                            })
                        } else {
                            completion(true)
                        }
                        
                    })
                }
                
            } else {
                completion(false)
            }
        }
        
    }
    
    static func setNewUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        //This is going to be called when the user is signing in from the sign in page, the auto loggin didnt work, or they are opening for first time, etc....
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if authResult != nil && error == nil {
                DataStorage.AutoLoggin.enable(email: email, password: password, completion: {})
                DataStorage.User.Name.fetch(completion: { (found, name) in
                    if found == true && name != "" {
                        DataStorage.WorkObjects.fetch(completion: { _ in
                            DataStorage.ClassStorage.pullFromCloud()
                            completion(true)
                        })
                    } else {
                        completion(false)
                    }
                })
            } else {
                completion(false)
            }
        }
        
    }
    
    static func signOut() {
        //This is a purposeful signout. The user hit the signout button in the preferences page
        
        try? Auth.auth().signOut()
        
        DataStorage.WorkObjects.Local.delete()
        DataStorage.User.Name.delete()
        DataStorage.User.ProfileImage.delete()
        DataStorage.AutoLoggin.disable()
        DataStorage.ClassStorage.Local.delete()
        DataStorage.WorkImages.Local.delete()
        
    }
    
}
