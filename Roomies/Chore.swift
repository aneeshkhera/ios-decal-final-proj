//
//  User.swift
//  Roomies
//
//  Created by Sam Steady on 12/6/16.
//  Copyright © 2016 Sam Steady. All rights reserved.
//

import Foundation

class Chore: NSObject, NSCoding {
    
    var name: String!
    var descript: String!
    var diff: String!
    var frequency: String!
    var date: Date!
    var isDone: String!
    
    convenience init(withName name: String, withDescription description: String, withDifficulty diff: String, withFrequency frequency: String, withDate date: Date) {
        self.init()
        self.name = name
        self.descript = description
        self.diff = diff
        self.frequency = frequency
        self.date = date
        self.isDone = "false"
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.name = decoder.decodeObject(forKey: "name") as! String
        self.descript = decoder.decodeObject(forKey: "description") as! String
        self.diff = decoder.decodeObject(forKey: "diff") as! String
        self.frequency = decoder.decodeObject(forKey: "frequency") as! String
        self.date = decoder.decodeObject(forKey: "date") as! Date
        self.isDone = decoder.decodeObject(forKey: "done") as! String
    }
    
    func encode(with aCoder: NSCoder)  {
        if let name = name { aCoder.encode(name, forKey: "name") }
        if let descript = descript { aCoder.encode(descript, forKey: "description") }
        if let diff = diff { aCoder.encode(diff, forKey: "diff") }
        if let frequency = frequency { aCoder.encode(frequency, forKey: "frequency") }
        if let date = date { aCoder.encode(date, forKey: "date") }
        if let isDone = isDone { aCoder.encode(isDone, forKey: "done") }
        
    }
    
}
