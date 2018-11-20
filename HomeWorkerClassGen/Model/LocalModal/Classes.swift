//
//  Classes.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 11/20/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation

struct Classes: Codable {
    
    public var name: String = ""
    public var id: String = ""
    var teacherCreated: Bool = false
    //This is going to have to evolve, but this is all that I have right now
    
    init(_ newName: String, byTeacher created: Bool) {
            name = newName
    }
    
}

