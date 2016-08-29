//
//  FirebaseHelper.swift
//  TheRestistance
//
//  Created by Alan Gao on 8/9/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import Foundation
import Firebase

/** This helper class provides methods that manage user information between the app and firebase.
    NOTE: Many function's return values via callbacks, as retrieving
          information from the database server takes time */
class FIRUser {
 
    /** If this is the user's first time using the app, this function will create 
        a new user in the Firebase Database with all of the supplied information. If the
        user has already used the app, Firebase will override the previous account information
        that they have provided with the newly supplied info. */
    static func createNewUser(userName: String, sessionCode: String, userCreatedHandler: (Void) -> Void) {
        FIRAuth.auth()?.signInAnonymouslyWithCompletion() { (user, error) in
            let userRef = FIRConstants.usersRef.child((user?.uid)!)
            userRef.child("username").setValue(userName)
            userRef.child("session").setValue(sessionCode)
            
            FIRUser.addUserToSession(sessionCode, username: userName)
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(sessionCode, forKey: "sessionCode")
            
            userCreatedHandler()
        }
    }
    
    /** Adds the current user (the one that's using the device) to the session that corresponds
        with the provided code. If the player disconnects, he/she will be removed from that session. */
    private static func addUserToSession(code: String, username: String) {
        let uid = FIRConstants.currentUser!.uid
        let sessionRef = FIRConstants.sessionsRef.child(code)
        let gameStartedRef = sessionRef.child("game started")
        
        gameStartedRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if(!snapshot.exists()) {
                gameStartedRef.setValue(false)
            }
            else {
                //Game has started
                print("Some value: \(snapshot.value)")
            }
        })
        
        sessionRef.child("players").child(uid).setValue("inLobby")
        sessionRef.child("inLobby").child(uid).setValue(username)
    }
    
    /** Returns information about a user in the form of a callback.
     The information returned depends on the childKey parameter */
    static func retrieveUserInfo(childKey: String, callback: (String?) -> Void) {
        let uid = FIRConstants.currentUser!.uid
        let sessionCodeRef = FIRConstants.usersRef.child(uid).child(childKey)
        
        sessionCodeRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let sessionCode = snapshot.value as! String
            callback(sessionCode)
        })
    }
    
    /** Deletes the current user from the session */
    static func deleteUserFromSession(sessionCode: String) {
        let uid = FIRConstants.currentUser!.uid
        let sessionRef = FIRConstants.sessionsRef.child(sessionCode)
        
        sessionRef.child("players").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            //playerStatus holds a string describing whether the player is in the lobby or game
            if let playerStatus = snapshot.value as? String {
                print(playerStatus)
                sessionRef.child(playerStatus).child(uid).removeValue()
            }
            
            sessionRef.child("players").child(uid).removeValue()
        })
        FIRConstants.usersRef.child(uid).child("session").setValue("nil")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("sessionCode")
    }
}
