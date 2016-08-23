//
//  ViewController.swift
//  TheRestistance
//
//  Created by Alan Gao on 8/8/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import UIKit
import Firebase

class CreateGameViewController: UIViewController {
    
    let code_length = 4
    @IBOutlet weak var usernameTextField: UITextField!
    
    /* Creates a new game session and generates a session code so othe users can join */
    @IBAction func createGameButton(sender: AnyObject) {
        let username = usernameTextField.text!
        
        if(username != "") {
            let code = generateSessionCode()
            
            FIRSessionCodes.storeSessionCode(code)
            FIRUser.createNewUser(username, sessionCode: code, userCreatedHandler: {
                 self.performSegueWithIdentifier("goToGameLobbyVC", sender: self)
            })
        }
        else {
            print("you need a username")
        }
    }
    
    /** Generates a random 4 digit code that will be 
        used to connect players into a single session */
    func generateSessionCode() -> String {
        var code: String = ""
        
        for _ in 0..<code_length {
            let randDigit = String(arc4random_uniform(10))
            code += randDigit
        }
        return code
    }
    
}

