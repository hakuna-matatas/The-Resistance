//
//  FIRConstants.swift
//  TheRestistance
//
//  Created by Alan Gao on 8/11/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import Foundation
import Firebase

struct FIRConstants {
    static let rootRef = FIRDatabase.database().reference()
    static let usersRef = FIRConstants.rootRef.child("users")
    static let sessionCodesRef = FIRConstants.rootRef.child("sessionCodes")
    static let sessionsRef = FIRConstants.rootRef.child("sessions")
    static let connectedRef = FIRConstants.rootRef.child(".info/connected")
    
    static let currentUser = FIRAuth.auth()?.currentUser
}