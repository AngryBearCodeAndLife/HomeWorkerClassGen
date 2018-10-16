//
//  HomeWork.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 9/27/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation

struct HomeWork: Codable {
    var assignmentName: String!
    var assignee: String!
    var wantsNotifications: Bool!
    var startDateString: String!
    var endDateString: String!
    var images: [String] = []
    var imageTitles: [String] = []
    var uid: String!
    
    var noteTitles: [String] = []
    var notes: [String] = []
    
    init(_ name: String, _ assigneeName: String, _ notifBool: Bool, _ endDate: Date, _ uid: String) {
        self.assignmentName = name
        self.assignee = assigneeName
        self.wantsNotifications = notifBool
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        
        let endString = dateFormatter.string(from: endDate)
        self.endDateString = endString
        
        let startString = dateFormatter.string(from: Date.init())
        self.startDateString = startString
        
        self.uid = uid
    }
    
    mutating func addAssocImage(id: String, title: String) {
        images.append(id)
        imageTitles.append(title)
    }
    
    mutating func addAssocNote(id: String, title: String) {
        notes.append(id)
        noteTitles.append(title)
    }
    
    func hasImages() -> Bool {
        if images != [] {
            return true
        } else {
            return false
        }
    }
    
    func hasNotes() -> Bool {
        if notes != [] {
            return true
        } else {
            return false
        }
    }
}

struct WorkTools {
    static func makeId() -> String {
        
        var canUse = false
        var key: String!
        
        while canUse == false {
            key = genkey()
            
            let currentWorks = LocalActions.WorkObjects.All.fetch()
            
            for work in currentWorks {
                if work.uid != key {
                    canUse = false
                } else {
                    canUse = true
                }
            }
        }
        
        return key
    }
    
    static func turnToDate(dateString: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter.date(from: dateString)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let finalDate = calendar.date(from:components)
        return finalDate!
    }
    
    static func genkey() -> String {
        let alpha = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        let randBool = [false, true]
        var strungId: String = ""
        
        for _ in 0...16 {
            if randBool[Int.random(in: 0 ..< 2)] {
                //generate a random number to add
                strungId = strungId + String(Int.random(in: 0 ..< 10))
            } else {
                //generate a random letter to add
                strungId = strungId + alpha[Int.random(in: 0 ..< 25)]
            }
        }
        
        return strungId
    }
    
}
