//
//  User.swift
//  Roomies
//
//  Created by Sam Steady on 12/6/16.
//  Copyright © 2016 Sam Steady. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    
    var name: String!
    var score: String!
    
    convenience init(withName name: String) {
        self.init()
        self.name = name
        self.score = "0"
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.name = decoder.decodeObject(forKey: "name") as! String
        self.score = decoder.decodeObject(forKey: "score") as! String
    }
    
    func encode(with aCoder: NSCoder)  {
        if let name = name { aCoder.encode(name, forKey: "name") }
        if let score = score { aCoder.encode(score, forKey: "score") }
    }
    
}
