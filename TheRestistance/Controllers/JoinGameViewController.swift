//
//  JoinGameViewController.swift
//  TheRestistance
//
//  Created by Alan Gao on 8/9/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import UIKit
import Firebase

class JoinGameViewController: UIViewController {

    @IBOutlet weak var invalidCodeLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var accessCodeTextField: UITextField!
    
    @IBAction func joinGameButton(sender: AnyObject) {
        if let sessionCode = accessCodeTextField.text {
            FIRSessionCodes.verifySessionCode(sessionCode, callback: { (codeVerified) in
                if(codeVerified) {
                    self.invalidCodeLabel.text = ""
                    let username = self.usernameTextField.text!
                    
                    FIRUser.createNewUser(username, sessionCode: sessionCode, userCreatedHandler: {
                        self.performSegueWithIdentifier("segueToGameLobbyVC", sender: self)
                    })
                }
                else {
                    self.invalidCodeLabel.text = "Invalid Code"
                }
            })
        }
    }

}
