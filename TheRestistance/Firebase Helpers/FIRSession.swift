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
    static func observeSessionInfo(sessionCode: String, addPlayerCallback: (String) -> Void, deletePlayerCallback: (String) -> Void) {
        let sessionRef = FIRConstants.sessionsRef.child(sessionCode)
        
        /* Called when a user joins the session via code */
        sessionRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let newPlayer = snapshot.value as! String
            addPlayerCallback(newPlayer)
        })
        
        /* Called when clicks the leave game button */
        sessionRef.observeEventType(.ChildRemoved, withBlock: { (snapshot) in
            let deletedPlayer = snapshot.value as! String
            deletePlayerCallback(deletedPlayer)
            
            /* If the session doesn't exist anymore, remove the corresponding session code */
            sessionRef.observeSingleEventOfType(.Value, withBlock: { (sessionSnap: FIRDataSnapshot) in
                if(!sessionSnap.exists()){
                    FIRConstants.sessionCodesRef.child(sessionCode).removeValue()
                }
            })
        })
    }
    
}
