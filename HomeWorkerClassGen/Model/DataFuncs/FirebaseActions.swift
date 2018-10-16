//
//  SaveToFirebase.swift
//  HomeWorker
//
//  Created by Ryan Topham on 8/12/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

struct FirebaseActions {
    
    //EVERYTHING TO DO WITH PROFILE IMAGE______________________________________________________________________
    
    struct ProfileImage {
        static func save(profilePhoto: UIImage) -> Bool {
            if let myUID = Auth.auth().currentUser?.uid {
                let storageRef = Storage.storage().reference().child("user/\(myUID)/profileImg")
                
                //Turn it into a jpeg with less quality, odds are you won't need too much detail in this photo. Always change later if need be
                let imageData = profilePhoto.jpegData(compressionQuality: 0.5)
                //Create the metadata file that will go with it in order to be able to know stuff about it later and in the cloud. Then declare that it is a jpeg image
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                
                var xerror = false
                
                //Save the image to the firebase storage location, that way to access it on another device
                storageRef.putData(imageData!, metadata: metadata) { (rMetadata, error) in
                    if error != nil && rMetadata == nil {
                        xerror = true
                    }
                }
                
                //Note: please refactor... looks like sh!t
                if xerror {
                    //There was an error
                    return false
                } else {
                    //There was not an error
                    return true
                }
            } else {
                return false
            }
        }
        
        static func fetch() {
            var profileImage: UIImage!
            
            //Reference the profile image in firebase
            let uid = Auth.auth().currentUser?.uid
            let storageRef = Storage.storage().reference().child("user/\(uid!)/profileImg")
            
            //This is going to download the data that was uploaded
            storageRef.getData(maxSize: 1 * 10240 * 10240) { data, error in
                if error != nil {
                    // Uh-oh, an error occurred!
                    profileImage = UIImage(named: "first")
                    // Mark: Do something if it doesn;t returun the image like we wanted
                } else {
                    // Data for my image is returned
                    profileImage = UIImage(data: data!)
                }
                LocalActions.ProfileImage.save(image: profileImage!)
            }
        }
    }
    
    //EVERYTHING TO DO WITH NAME _______________________________________________________________________________
    
    struct Name {
        static func save(name: String) {
            
            let currentUID = Auth.auth().currentUser?.uid
            
            let stringPath = "/users/\(String(describing: currentUID!))/name"
            Database.database().reference().child(stringPath).setValue(name)
        }
        
        static func fetch() {
            var name: String!
            let currentUID = Auth.auth().currentUser?.uid
            let namePath = "users/\(String(describing: currentUID!))/name"
            Database.database().reference().child(namePath).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                name = snapshot.value! as? String
                if name != nil && name != "" {
                    LocalActions.Name.save(name: name)
                }
            })
        }
    }
    
    //EVERYTHING TO DO WITH WORK OBJECTS______________________________________________________________________
    
    struct WorkObjects {
        
        static func save(_ newWork: HomeWork) {
            print("RUNNING THE FUNCTION TO SAVE THE WORK TO THE CLOUD")
            let stringPath = "/work/"
            let databaseReference = Database.database().reference().child(stringPath).childByAutoId()
            let workKey = databaseReference.key
            let finalPath = "/work/\(String(describing: workKey))"
            let lastDatabaseRef = Database.database().reference().child(finalPath)
            
            lastDatabaseRef.child("assignee").setValue(newWork.assignee)
            lastDatabaseRef.child("assignmentName").setValue(newWork.assignmentName)
            lastDatabaseRef.child("endDateString").setValue(newWork.endDateString)
            lastDatabaseRef.child("notifications").setValue(newWork.wantsNotifications)
            lastDatabaseRef.child("startDateString").setValue(newWork.startDateString)
            
            self.User.save(id: workKey)
            let endDateForLocal = WorkTools.turnToDate(dateString: newWork.endDateString)
            let localWork = HomeWork(newWork.assignmentName, newWork.assignee, newWork.wantsNotifications, endDateForLocal, workKey)
            LocalActions.WorkObjects.save(newWork: localWork)
        }
        
        static func fetch(completion: @escaping ([HomeWork]) -> Void) {
            self.User.exists { (exists) in
                if exists {
                    var finalWork: [HomeWork] = []
                    //the work is there, lets go get it
                    self.User.fetch(completion: { (workIds) in
                        print("IS RUNNING THE FETCH FUNCITON IN ORDER TO GET THE ARRAY")
                        print(workIds)
                        for (value, id) in workIds.enumerated() {
                            print("IS RUNNING IT FOR ANOTHER ID")
                            self.fetchOne(id: id, completion: { (fetchedWork) in
                                print("IS GOING TO BE APPENDING WORK")
                                finalWork.append(fetchedWork)
                                if value == workIds.count - 1 {
                                    completion(finalWork)
                                }
                            })
                            
                        }
                        
                    })
                    
                } else {
                    completion([HomeWork("You don't have any work in the cloud", "Me", false, Date.distantFuture, "randidthatdoesntmatter")])
                }
            }
        }
        
        private static func fetchOne(id: String, completion: @escaping (HomeWork) -> Void) {
            
            let path = "work/\(String(describing: id))"
            let reference = Database.database().reference().child(path)
            
            reference.observeSingleEvent(of: .value) { (snapshot) in
                
                let name = snapshot.childSnapshot(forPath: "assignmentName").value! as? String
                let assignee = snapshot.childSnapshot(forPath: "assignee").value! as? String
                let notifWant = snapshot.childSnapshot(forPath: "notifications").value! as? Bool
                let eDateS = snapshot.childSnapshot(forPath: "endDateString").value! as? String
                let eDate = WorkTools.turnToDate(dateString: eDateS!)
                //Create the work, and send it back using the completion thingy
                var workFromCloud = HomeWork(name!, assignee!, notifWant!, eDate, id)
                print(workFromCloud)
                
                self.Images.exists(workId: id, completion: { (exists) in
                    if exists {
                        //There are images we should fetch
                        self.Images.fetch(workId: id, completion: { (imgArr) in
                            imgArr.forEach({ (imgStr) in
                                self.Images.save(id: imgStr, workId: id)
                                workFromCloud.addAssocImage(id: imgStr, title: "THIS IS GOING TO HAVE TO DO FOR NOW")
                            })
                            completion(workFromCloud)
                        })
                    } else {
                        //Just continue with the work object the way that it is
                        completion(workFromCloud)
                    }
                })
                
                
                
            }
        }
        
        struct Images {
            //Do the work with the images that are associated to the work here
            
            static func save(id: String, workId: String) {
                self.exists(workId: workId) { (exists) in
                    if exists {
                        //There is other images that have been saved in the past, please don't forget these
                        var ids: [String] = []
                        self.fetch(workId: workId, completion: { (idArray) in
                            ids = idArray
                            ids.append(id)
                            //let currentUID = Auth.auth().currentUser?.uid
                            let path = "work/\(String(describing: workId))/imageIds"
                            let reference = Database.database().reference().child(path)
                            
                            //Add the work id to the users list of work ids
                            reference.setValue(ids)
                        })
                    } else {
                        //there is nothing, so just save it please
                        let currentUID = Auth.auth().currentUser?.uid
                        let path = "work/\(String(describing: workId))/imageIds"
                        let reference = Database.database().reference().child(path)
                        
                        //Add the work id to the users list of work ids
                        reference.setValue([id])
                    }
                }
            }
            
            static func fetch(workId: String, completion: @escaping ([String]) -> Void) {
                print("RUNNING THE FETCH FUNCITON")
                var returnArray: [String] = []
                
                let currentUID = Auth.auth().currentUser?.uid
                let path = "work/\(String(describing: workId))/imageIds"
                let reference = Database.database().reference().child(path)
                
                reference.observeSingleEvent(of: .value) { (snapshot) in
                    print("IS OBSERVING SOMETHING")
                    let value = snapshot.value as? [String]
                    returnArray = value!
                    completion(returnArray)
                }
            }
            
            static func exists(workId: String, completion: @escaping (Bool) -> Void) {
                print("RUNNING THE EXISTS FUNCTION")
                let currentUID = Auth.auth().currentUser?.uid
                let stringPath = "work/\(String(describing: workId))/imageIds"
                let ref = Database.database().reference().child(stringPath)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.hasChild("0"){
                        print("CONTINUING RUN LIKE WE HAVE CHILDREN")
                        completion(true)
                    }else{
                        print("CONTINUING RUN LIKE WE DONT HAVE CHILDREN")
                        completion(false)
                    }
                })
            }
            
        }
        
        struct User {
            static func save(id: String) {
                print("RUNNING THE SAVE FUNCTION IN USERS")
                self.exists(completion: { (exists) in
                    if exists {
                        print("I agree, we have children")
                        var workArray: [String] = []
                        self.fetch(completion: { (workIds) in
                            print("THIS IS WHERE I WENT WRONG")
                            workArray = workIds
                            workArray.append(id)
                            self.push(work: workArray)
                        })
                    } else {
                        print("I disagree, we dont have children")
                        //There is no other work, and we should just save the new one
                        self.push(work: [id])
                    }
                })
            }
            
            private static func push(work: [String]) {
                print("RUNNING THE PUCH FUNCTION")
                let currentUID = Auth.auth().currentUser?.uid
                let path = "users/\(String(describing: currentUID!))/work"
                let reference = Database.database().reference().child(path)
                
                //Add the work id to the users list of work ids
                reference.setValue(work)
                print("DONE!")
            }
            
            static func fetch(completion: @escaping ([String]) -> Void) {
                print("RUNNING THE FETCH FUNCITON")
                var returnArray: [String] = []
                
                let currentUID = Auth.auth().currentUser?.uid
                let path = "users/\(String(describing: currentUID!))/work"
                let reference = Database.database().reference().child(path)
                
                reference.observeSingleEvent(of: .value) { (snapshot) in
                    print("IS OBSERVING SOMETHING")
                    let value = snapshot.value as? [String]
                    returnArray = value!
                    completion(returnArray)
                }
            }
            static func exists(completion: @escaping (Bool) -> Void) {
                print("RUNNING THE EXISTS FUNCTION")
                let currentUID = Auth.auth().currentUser?.uid
                let stringPath = "users/\(String(describing: currentUID!))/work"
                let ref = Database.database().reference().child(stringPath)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.hasChild("0"){
                        print("CONTINUING RUN LIKE WE HAVE CHILDREN")
                        completion(true)
                    }else{
                        print("CONTINUING RUN LIKE WE DONT HAVE CHILDREN")
                        completion(false)
                    }
                })
            }
        }
    }
    
    //EVRYTHING TO DO WITH WORK IMAGES________________________________________________________________________
    
    struct WorkImages {
        
        static func save(image: UIImage, id: String) {
            let storageRef = Storage.storage().reference().child("work").child("images").child(id)
            
            //Turn it into a jpeg with less quality, odds are you won't need too much detail in this photo. Always change later if need be
            let imageData = image.jpegData(compressionQuality: 0.5)
            //Create the metadata file that will go with it in order to be able to know stuff about it later and in the cloud. Then declare that it is a jpeg image
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            //Save the image to the firebase storage location, that way to access it on another device
            storageRef.putData(imageData!, metadata: metadata) { (rMetadata, error) in
                if error != nil && rMetadata == nil {
                    print(error?.localizedDescription)
                } else {
                    print("We were able to save the image to firebase storage")
                }
            }
            
        }
        
        
    }
    
}
