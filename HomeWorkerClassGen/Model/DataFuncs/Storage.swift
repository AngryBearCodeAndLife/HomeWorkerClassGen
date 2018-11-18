//
//  Storage.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 11/16/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SwiftyJSON
import Disk
import SwiftKeychainWrapper

struct DataStorage {
    
    static func changeNotif() {
        if let myUID = Auth.auth().currentUser?.uid {
            let path = "users/\(myUID)/update"
            let ref = Database.database().reference().child(path)
            ref.setValue(true)
        }
    }
    
    struct User {
        
        struct ProfileImage {
            
            public static func fetch(completion: @escaping (UIImage) -> Void) {
                //Called whenever the code needs to access the image from local storage(e.g. when the tabbar updates, preference page, etc....
                
                if Local.exists() {
                    completion(Local.fetch())
                } else {
                    //This running means that the image was not in local storgae
                    //need to fetch from firebase, and then save to local. At that point, we can then return it from local storage
                    
                    Cloud.retrieve { (found, newProfilePic) in
                        if found {
                            Local.save(newProfilePic, completion: { (finished) in
                                if finished {
                                    completion(Local.fetch())
                                } else {
                                    print("Hey! Capt. We have a problem")
                                }
                            })
                        } else {
                            //This means that the image was not found in the cloud, and we are going to need to just save a dumb image, and then call it back.
                            Local.save(UIImage(named: "NewOrange")!, completion: { (finished) in
                                if finished {
                                    completion(Local.fetch())
                                } else {
                                    print("Um... capt?? We have a problem. You tried saving an image I knw is there, but it wont return it.")
                                }
                            })
                        }
                    }
                    
                }
                
            }
            
            public static func save(_ image: UIImage, completion: @escaping (Bool) -> Void) {
                //Called when the user first signs in
                //purpose: to download it form thecloud, and then save to local storage.
                
                if let myUID = Auth.auth().currentUser?.uid {
                    let profileImageRef = Storage.storage().reference().child("user/\(myUID)/profileImg")
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpg"
                    profileImageRef.putData(image.jpegData(compressionQuality: 0.75)!, metadata: metadata) { (sMeta, error) in
                        if error == nil {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    }
                }
                
            }
            
            public func update(_ newImage: UIImage, completion: @escaping (Bool) -> Void) {
                //Called when the user updatews their image from the preferences page.
                
                Cloud.save(profileImage: newImage) { (saveSuccess) in
                    if saveSuccess {
                        //This means the image was successfully saved to firebase, and the profile image has been updated. can now save to local storage, and then return true should that work
                        
                        Local.save(newImage, completion: { (success) in
                            if success {
                                completion(true)
                            } else {
                                //Should also probably take the image back from firebase, but can deal with that later.
                                completion(false)
                            }
                        })
                        
                    } else {
                        //This means the image was not saved to the cloud, and therefore was not saved locally. The completion function should tell the user that the image was not saved
                        completion(false)
                    }
                }
                
            }
            
            public static func delete(completion: @escaping (Bool) -> Void = { _ in }) {
                //Called when a user signs out to make sure that their old profile picture was deleted. Coudl be updated anyway. Will not be called when the app quits and the user is signed out, becaue when we sign back in, the user will likely be brought right to the page, and there is no need to redownoad the image.
                
                Local.delete { success in
                    completion(success)
                }
                
            }
            
            struct Local {
                
                static func exists() -> Bool {
                    //Will return if the picture is in the local storage
                    return Disk.exists("profileImage.jpeg", in: .caches)
                }
                
                static func fetch() -> UIImage {
                    
                    let image = try! Disk.retrieve("profileImage.jpeg", from: .caches, as: UIImage.self)
                    return image
                    
                }
                
                static func save(_ image: UIImage, completion: @escaping (Bool) -> Void) {
                    
                    var success = true
                    
                    do {
                        try Disk.save(image, to: .caches, as: "profileImage.jpeg")
                    } catch {
                        success = false
                    }
                    
                    completion(success)
                    
                    
                }
                
                static func delete(completion: @escaping (Bool) -> Void) {
                    
                    var success = true
                    
                    do {
                        try Disk.save(UIImage(named: "NewOrange")!, to: .caches, as: "profileImage.jpeg")
                    } catch {
                        success = false
                    }
                    
                    completion(success)
                    
                }
                
            }
            
            private struct Cloud {
                
                static func retrieve(completion: @escaping (Bool, UIImage) -> Void) {
                    
                    if let myUID = Auth.auth().currentUser?.uid {
                        
                        //there is currently a user signed in. We shouldbe good to ask firebase for a profile picture.
                        let storageRef = Storage.storage().reference().child("user/\(myUID)/profileImg")
                        
                        storageRef.getData(maxSize: 1 * 10240 * 10240) { (data, error) in
                            if error != nil {
                                //Uh-oh an error occured
                                completion(false, UIImage())
                            } else {
                                completion(true, UIImage(data: data!)!)
                            }
                        }
                        
                    }
                    
                }
                
                static func save(profileImage: UIImage, completion: @escaping (Bool) -> Void) {
                    
                    if let myUID = Auth.auth().currentUser?.uid {
                        
                        let storageRef = Storage.storage().reference().child("user/\(myUID)/profileImg")
                        
                        let imageData = profileImage.jpegData(compressionQuality: 0.7)
                        let metadata = StorageMetadata()
                        metadata.contentType = "image/jpg"
                        
                        storageRef.putData(imageData!, metadata: metadata) { (rMetadata, error) in
                            
                            if error != nil && rMetadata == nil {
                                completion(false)
                            } else {
                                completion(true)
                            }
                            
                        }
                        
                    } else {
                        completion(false)
                    }
                    
                }
                
            }
            
        }
        
        struct Name {
            
            static func save(_ name: String, completion: @escaping (Bool) -> Void) {
            
                //Push to the cloud.
                //If that works, going to save to local storage
                //Should both of those work, completion(true)
                
                Cloud.save(name) { success in
                    if success {
                        //Save it to the local storage
                        
                        Local.save(name)
                        completion(true)
                        
                    } else {
                        //Compeltion function should notify the user that it was impossible to save their name
                        completion(false)
                    }
                }
                
            }
            
            static func fetch(completion: @escaping (Bool, String) -> Void) {
                
                if Local.exists() {
                    
                    completion(true, Local.fetch())
                    
                } else {
                    //The name was not found locally. Need to go to the cloud, and try to find it.
                    
                    Cloud.fetch { (found, name) in
                        if !found {
                            //This means that the name was not found in the cloud
                            //Completion should definitely do someting abotu this. It wasnt sotred locally, and it wasnt found in thecloud... oh boy
                            print(("hey.... boyd could find anthign related to this persons name, even thoguh they are supposedly signed in."))
                            completion(false, String())
                        } else {
                            Local.save(name)
                            completion(true, name)
                        }
                    }
                    
                }
                
            }
            
            static func delete() {
                Local.delete()
            }
            
            struct Cloud {
                
                static func fetch(completion: @escaping (Bool, String) -> Void) {
                    
                    if let myUID = Auth.auth().currentUser?.uid {
                        
                        let namePath = "users/\(myUID)/name"
                        
                        Database.database().reference().child(namePath).observeSingleEvent(of: DataEventType.value) { (snapshot) in
                            var name: String!
                            name = snapshot.value! as? String
                            if name != nil && name != "" {
                                completion(true, name)
                            } else {
                                completion(false, name)
                            }
                        }
                        
                    }
                    
                }
                
                static func save(_ name: String, completion: @escaping (Bool) -> Void) {
                    
                    if let myUID = Auth.auth().currentUser?.uid {
                        let namePath = "users/\(myUID)/name"
                        Database.database().reference().child(namePath).setValue(name) { (error, hello) in
                            if error == nil {
                                completion(true)
                            } else {
                                completion(false)
                            }
                        }
                    } else {
                        completion(false)
                    }
                    
                }
                
            }
            
            struct Local {
                
                static func fetch() -> String {
                    
                    return UserDefaults.standard.string(forKey: "Username")!
                    
                }
                
                static func save(_ name: String) {
                    
                    UserDefaults.standard.set(name, forKey: "Username")
                    
                }
                
                static func exists() -> Bool {
                    if UserDefaults.standard.string(forKey: "Username") != nil {
                        return true
                    } else {
                        return false
                    }
                }
                static func delete() {
                    UserDefaults.standard.set(nil, forKey: "Username")
                }
                
            }
            
        }
        
        struct Work {
            
            static func save(_ newId: String, completion: @escaping () -> Void) {
                //This function is going to save the uid to the user. Only called from the WorkObjects.save()
                
                exists { found in
                    if found {
                        
                        var idArray: [String] = []
                        
                        fetch(completion: { existingIDS in
                            
                            idArray = existingIDS
                            idArray.append(newId)
                            
                            push(idArray)
                            
                            completion()
                            
                        })
                        
                    } else {
                        
                        if let myUID = Auth.auth().currentUser?.uid {
                            let idRef = Database.database().reference().child("users/\(myUID)/work/")
                            idRef.setValue([newId])
                        }
                    }
                }
                
            }
            
            static func push(_ ids: [String]) {
                
                if let myUID = Auth.auth().currentUser?.uid {
                    
                    let path = "users/\(myUID)/work"
                    let ref = Database.database().reference().child(path)
                    
                    ref.setValue(ids)
                    
                }
                
            }
            
            static func fetch(completion: @escaping ([String]) -> Void) {
                
                var returnArray: [String] = []
                if let myUID = Auth.auth().currentUser?.uid {
                    let path = "users/\(myUID)/work"
                    let ref = Database.database().reference().child(path)
                    ref.observeSingleEvent(of: .value) { snapshot in
                        let value = snapshot.value!
                        returnArray = value as! [String]
                        completion(returnArray)
                    }
                } else {
                    completion(returnArray)
                }
                
            }
            
            static func exists(completion: @escaping (Bool) -> Void) {
                
                if let myUID = Auth.auth().currentUser?.uid {
                    
                    let workPath = "users/\(myUID)/work"
                    let ref = Database.database().reference().child(workPath)
                    ref.observeSingleEvent(of: .value) { snapshot in
                        if snapshot.hasChild("0") {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    }
                    
                }
                
            }
            
        }
        
    }
    
    struct WorkObjects {
        
        static func fetch(id: String = "", completion: @escaping ([HomeWork]) -> Void) {
            
            if id != "" {
                //This means that we are retrieving one object that has the id that was passed to the function
                //Called in example of trying to move to an assignment view
            
                let allLocalWork = Local.fetch()
                for work in allLocalWork {
                    if work.uid == id {
                        completion([work])
                    }
                }
                
            } else {
                //We need to return all of the homeworks found.
                //Called when we are updating the view, or logging back into the app
                
                //Should pull everything from the cloud, resave it locally, and then return what we needed
                Cloud.fetch { works in
                    
                    Local.save(works)
                    completion(works)
                    
                }
                
            }
            
        }
        
        static func save(_ newWork: HomeWork, completion: @escaping () -> Void) {
            Cloud.save(newWork) { workWithKey in
                Local.save(workWithKey)
                User.Work.save(workWithKey.uid, completion: {
                    completion()
                })
            }
        }
        
        static func delete(completion: @escaping () -> Void) {
            
            //This will be called when a user signs out for good. This won't be brought on by just quitting the app, though in essence it will be anyway.
            
            Local.delete()
            
        }
        
        static func delete(_ id: String, completion: @escaping () -> Void) {
            
            //This is run when a user deletes an assignment from their group. It will both be taken out of the cloud, possibly in the future moved to the archives, to be returned if needed, and then removed locally, their list will appear to be updated.
            
            Cloud.delete(id) {
                
                Local.delete(id)
                completion()
                
            }
            
        }
        
        struct Cloud {
            
            static func delete(_ id: String, completion: @escaping () -> Void) {
                
                let path = "work/\(id)"
                let ref = Database.database().reference().child(path)
                ref.removeValue()
                if let myUID = Auth.auth().currentUser?.uid {
                    let uPath = "users/\(myUID)/work/\(id)"
                    let uRef = Database.database().reference().child(uPath)
                    uRef.removeValue()
                    completion()
                }
                
            }
            
            static func fetch(completion: @escaping ([HomeWork]) -> Void) {
                User.Work.exists { found in
                    if found {
                        User.Work.fetch { ids in
                            var finalWork: [HomeWork] = []
                            for (value, id) in ids.enumerated() {
                                fetchOne(id, completion: { fetchedWork in
                                    finalWork.append(fetchedWork)
                                    if value == ids.count - 1 {
                                        completion(finalWork)
                                    }
                                })
                            }
                        }
                    } else {
                        completion([])
                    }
                }
            }
            
            static private func fetchOne(_ id: String, completion: @escaping (HomeWork) -> Void) {
                
                let path = "work/\(id)"
                let ref = Database.database().reference().child(path)
                ref.observeSingleEvent(of: .value) { snapshot in
                    let name = snapshot.childSnapshot(forPath: "assignmentName").value! as? String
                    let assignee = snapshot.childSnapshot(forPath: "assignee").value! as? String
                    let eDateS = snapshot.childSnapshot(forPath: "endDateString").value! as? String
                    let eDate = WorkTools.turnToDate(dateString: eDateS!)
                    let workFromCloud = HomeWork(name!, assignee!, true, eDate, id)
                    //Need to check if there are work images associated with this that we can find either locally or in the cloud. Then run completion with that object.
                    completion(workFromCloud)
                }
            }
            
            static func save(_ work: HomeWork, completion: @escaping (HomeWork) -> Void) {
                let workPath = "/work/"
                let databaseReference = Database.database().reference().child(workPath).childByAutoId()
                let workKey = databaseReference.key!
                
                databaseReference.child("assignee").setValue(work.assignee)
                databaseReference.child("assignmentName").setValue(work.assignmentName)
                databaseReference.child("endDateString").setValue(work.endDateString)
                databaseReference.child("notifications").setValue(work.wantsNotifications)
                databaseReference.child("startDateString").setValue(work.startDateString)
                
                let endDate = WorkTools.turnToDate(dateString: work.endDateString)
                
                let returningWork = HomeWork(work.assignmentName, work.assignee, work.wantsNotifications, endDate, workKey)
                completion(returningWork)
            }
            
        }
        
        struct Local {
            
            static func delete(_ id: String) {
                let existingLocalWorks = try? Disk.retrieve("work.json", from: .caches, as: [HomeWork].self)
                var saveWorks: [HomeWork]! = existingLocalWorks
                var madeChange = false
                for (index, work) in saveWorks.enumerated() {
                    if work.uid == id {
                        saveWorks.remove(at: index)
                        madeChange = true
                    }
                }
                if madeChange {
                    save(saveWorks)
                }
            }
            
            static func delete() {
                try? Disk.remove("work.json", from: .caches)
            }
            
            static func save(_ works: [HomeWork]) {
                
                try! Disk.save(works, to: .caches, as: "work.json")
                
            }
            
            static func save(_ work: HomeWork) {
                
                var existing: [HomeWork] = []
                
                if exists() {
                    
                    existing = fetch()
                    existing.append(work)
                    
                } else {
                    existing.append(work)
                }
                
                try! Disk.save(existing, to: .caches, as: "work.json")
                
            }
            
            static func fetch(_ id: String = "") -> [HomeWork] {
                
                var workArray: [HomeWork] = []
                var retrievedArray: [HomeWork] = []
                
                do {
                    retrievedArray = try Disk.retrieve("work.json", from: .caches, as: [HomeWork].self)
                    try Disk.remove("work.json", from: .caches)
                } catch {
                    retrievedArray = []
                }
                
                if id == "" {
                    return retrievedArray
                } else {
                    for work in retrievedArray {
                        if work.uid == id {
                            workArray.append(work)
                        }
                    }
                    return workArray
                }
                
            }
            
            static func exists() -> Bool {
                
                return Disk.exists("work.json", in: .caches)
                
            }
            
        }
        
    }
    
    struct AutoLoggin {
        
        static func isEnabled() -> Bool {
            return UserDefaults.standard.bool(forKey: "hasAutoSignIn")
        }
        
        static func password() -> String {
            
            if isEnabled() {
                return KeychainWrapper.standard.string(forKey: "userPassword")!
            } else {
                return ""
            }
            
        }
        
        static func email() -> String {
            
            if isEnabled() {
                return KeychainWrapper.standard.string(forKey: "userEmail")!
            } else {
                return ""
            }
            
        }
        
        static func enable(email: String, password: String, completion: @escaping () -> Void = { }) {
            
            if isEnabled() {
                disable()
            }
            
            let eSaveSuccessful: Bool = KeychainWrapper.standard.set(email, forKey: "userEmail")
            let pSaveSuccessful: Bool = KeychainWrapper.standard.set(password, forKey: "userPassword")
            if eSaveSuccessful && pSaveSuccessful {
                UserDefaults.standard.set(true, forKey: "hasAutoSignIn")
            }
            completion()
        }
        
        static func disable(completion: @escaping (Bool) -> Void = { _ in }) {
            
            let eSaveSuccess: Bool = KeychainWrapper.standard.set(String(), forKey: "userEmail")
            let pSaveSuccess: Bool = KeychainWrapper.standard.set(String(), forKey: "userPassword")
            
            if eSaveSuccess && pSaveSuccess {
                UserDefaults.standard.set(false, forKey: "hasAutoSignIn")
                completion(true)
            } else {
                completion(false)
            }
            
        }
    }
    
    struct WorkImages {
        
    }
    
    struct WorkNotes {
        
    }
    
    
}
