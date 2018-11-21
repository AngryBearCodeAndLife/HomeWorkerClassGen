//
//  JunkFile.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 11/21/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
//
//static func new(_ newClass: Classes, completion: @escaping (Bool, String) -> Void) {
//
//    if let myUID = Auth.auth().currentUser?.uid {
//        let path = "classes"
//        let ref = Database.database().reference().child(path).childByAutoId()
//        let classKey = ref.key!
//
//        ref.child("name").setValue(newClass.name) { (error, dataRef) in
//            if error == nil {
//                //Save the class to the user
//                let userpath = "users/\(myUID)/classes"
//                let userRef = Database.database().reference().child(userpath)
//                //Going to need to find theother classes here, and add the new one, not just kill the others.
//
//                userRef.observeSingleEvent(of: .value, with: { snapshot in
//
//                    let value = snapshot.value!
//
//                    var existingClasses: [String]!
//
//                    if value as? String != nil {
//                        existingClasses = value as! [String]
//                    } else {
//                        existingClasses = []
//                    }
//
//                    existingClasses.append(classKey)
//                    userRef.setValue(existingClasses, withCompletionBlock: { (error, dataRefUser) in
//                        if error == nil {
//                            completion(true, classKey)
//                        } else {
//                            completion(false, String())
//                        }
//                    })
//
//                })
//
//
//            } else {
//                completion(false, String())
//            }
//        }
//    }
//}
