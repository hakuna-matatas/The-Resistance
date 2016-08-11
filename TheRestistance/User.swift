//
//  User.swift
//  TheRestistance
//
//  Created by Alan Gao on 8/9/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import Foundation

class User {
    var username: String
    var sessionCode: String
    
    init(username: String, sessionCode: String) {
        self.username = username
        self.sessionCode = sessionCode
    }  
    
}