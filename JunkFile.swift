//
//  JunkFile.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 11/21/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

//import Foundation
//
//struct WorkImages {
//
//    //NOTE: I have no way of finding these images when I sign back in right now. They will be gone as soon as I sign out forcefully. Well, stuck in storage, but not accessible
//
//    static func newImage(_ image: UIImage, with work: HomeWork, completion: @escaping (Bool) -> Void) {
//
//        print("Trying to run the newImage function to save it")
//
//        Cloud.new(image, with: work) { success, newKey in
//            if success {
//                Local.save(image, to: work, with: newKey, completion: { success in
//                    completion(success)
//                })
//            } else {
//                completion(false)
//            }
//        }
//
//    }
//
//    static func removeImage(_ id: String, completion: @escaping (Bool) -> Void) {
//        //Not going to worry about this right now, dont need to talk abuot it, since I have no way to do it
//    }
//
//    static func fetch(for work: HomeWork) -> [UIImage] {
//        var images: [UIImage] = []
//        for imageId in work.images {
//            images.append(Local.fetch(imageId))
//        }
//        return images
//    }
//
//    struct Local {
//
//        static func fetch(_ id: String) -> UIImage {
//
//            do {
//                let newImage = try Disk.retrieve("\(id).jpeg", from: .caches, as: UIImage.self)
//                return newImage
//            } catch {
//                print("Cannot find the image that you want")
//                return UIImage()
//            }
//
//        }
//
//        static func save(_ image: UIImage, to work: HomeWork, with id: String, completion: @escaping (Bool) -> Void) {
//            //here we are going to have to save the image to local storage using the id that was given from the cloud
//            do {
//                try Disk.save(image, to: .caches, as: "\(id).jpeg")
//            } catch {
//                print("We were unable to save the image to local storage. This is cause for alarm")
//            }
//
//            //Then we are going to have to pull back the work that is in the storage, and change the one image thing in the homework, and resave the rest of it
//
//            DataStorage.WorkObjects.fetch { foundWorks in
//                var toChangeWork: HomeWork!
//                for hiddenWork in foundWorks {
//                    if hiddenWork.uid == work.uid {
//                        DataStorage.WorkObjects.delete(hiddenWork.uid, completion: {
//                            toChangeWork = hiddenWork
//                            toChangeWork.images.append(id)
//                            DataStorage.WorkObjects.save(toChangeWork, completion: {
//                                completion(true)
//                            })
//                        })
//                    }
//                    break
//                }
//            }
//        }
//    }
//
//    struct Cloud {
//
//        static func new(_ image: UIImage, with work: HomeWork, completion: @escaping (Bool, String) -> Void) {
//            if let myUID = Auth.auth().currentUser?.uid {
//
//                let path = "work/\(work.uid!)/images"
//                let keyRef = Database.database().reference().childByAutoId()
//                let newKey = keyRef.key
//                let trueRef = Database.database().reference().child(path)
//
//                fetch(for: work) { ids in
//
//                    var newIds = ids
//                    newIds.append(newKey!)
//
//                    trueRef.setValue(newIds, withCompletionBlock: { error, _ in
//                        if error == nil {
//                            //Now the new id has been associated with the image that hasnt been uploaded to storage. Do that here
//
//                            let storagePath = "workImgs/\(myUID)/\(work.uid!)/\(newKey!).jpeg"
//                            let storageRef = Storage.storage().reference().child(storagePath)
//                            let imgToUp = image.jpegData(compressionQuality: 1.0)
//                            let metaData = StorageMetadata()
//                            metaData.contentType = "image/jpg"
//                            storageRef.putData(imgToUp!, metadata: metaData, completion: { (sMeta, error) in
//                                if error == nil {
//                                    completion(true, newKey!)
//                                } else {
//                                    completion(false, String())
//                                }
//                            })
//
//                        } else {
//                            completion(false, String())
//                        }
//                    })
//
//                }
//
//            }
//        }
//
//        static func fetch(for work: HomeWork, completion: @escaping ([String]) -> Void) {
//
//            let path = "work/\(work.uid!)/images"
//            let dataRef = Database.database().reference().child(path)
//
//            dataRef.observeSingleEvent(of: .value) { snapshot in
//                var workImageIds = snapshot.value! as? [String]
//                if workImageIds == nil {
//                    workImageIds = []
//                }
//                completion(workImageIds!)
//            }
//
//        }
//
//    }
//
//}
