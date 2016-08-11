//
//  FIRSessionCodes.swift
//  TheRestistance
//
//  Created by Alan Gao on 8/11/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import Foundation
import Firebase

/** This helper class provides methods that manage session code information between the app and firebase.
 NOTE: Many function's return values via callbacks, as retrieving
 information from the database server takes time */
class FIRSessionCodes {
    /** Stores the session codes for every ongoing session. Codes are stored for two reasons:
     
     1. To ensure no duplicate codes are created
     2. To determine whether a submitted session code is legitimate */
    static func storeSessionCode(sessionCode: String) {
        let sessionCodeRef = FIRConstants.sessionCodesRef.child(sessionCode)
        sessionCodeRef.setValue(true)
    }
    
    static func verifySessionCode(sessionCode: String, callback: (Bool) -> Void) {
        FIRConstants.sessionCodesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            for code in snapshot.children {
                let code_string = code.key!
                
                if(code_string == sessionCode) {
                    callback(true)
                }
                else {
                    callback(false)
                }
            }
            
        })
    }
}