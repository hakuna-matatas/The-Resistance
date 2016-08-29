//
//  FIRRetrieveInfo.swift
//  TheRestistance
//
//  Created by Alan Gao on 8/11/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import Foundation
import Firebase

/** This helper class provides methods that manage session information between the app and firebase.
 NOTE: Many function's return values via callbacks, as retrieving
 information from the database server takes time */
class FIRSession {
    
    /** Listens for players that are added or removed from a session. Returns added
     and removed player information through two separate callbacks that each return
     the uid of the added/removed player */
    static func observeSessionInfo(sessionCode: String,
                                   addPlayerCallback: (String) -> Void,
                                   deletePlayerCallback: (String) -> Void,
                                   gameChangedStateCallback: (Bool) -> Void) {
        
        let sessionRef = FIRConstants.sessionsRef.child(sessionCode)
        let playersInSessionRef = sessionRef.child("players")
        let inLobbySessionRef = sessionRef.child("inLobby")
        
        /* Called when a user joins the session via code */
        inLobbySessionRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let newPlayer = snapshot.value as! String
            addPlayerCallback(newPlayer)
        })
        
        /* Called when clicks the leave game button */
        inLobbySessionRef.observeEventType(.ChildRemoved, withBlock: { (snapshot) in
            let deletedPlayer = snapshot.value as! String
            deletePlayerCallback(deletedPlayer)
            
            /* If the session doesn't exist anymore, remove the 
               corresponding session code AND session information */
            playersInSessionRef.observeSingleEventOfType(.Value, withBlock: { (sessionSnap) in
                if(!sessionSnap.exists()){
                    FIRConstants.sessionCodesRef.child(sessionCode).removeValue()
                    sessionRef.removeValue()
                }
            })
        })
        
        /* Called when the game starts or when it ends */
        sessionRef.observeEventType(.ChildChanged, withBlock: { (snapshot) in
            if let inProgress = snapshot.value as? Bool {
                gameChangedStateCallback(inProgress)
            }
        })
    }
    
    static func startSession(sessionCode: String) {
        let gameStartedRef = FIRConstants.sessionsRef.child(sessionCode).child("game started")
        
        gameStartedRef.setValue(true)
    }
    
}








