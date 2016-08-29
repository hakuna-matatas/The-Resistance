//
//  GameLobbyViewController.swift
//  TheRestistance
//
//  Created by Alan Gao on 8/9/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import UIKit

class GameLobbyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var accessCodeLabel: UILabel!
    @IBOutlet weak var playerTableView: UITableView!
    
    let number_of_sections = 1
    let header_text = "Players currently in the lobby:"
    
    var playersInLobby = [String]() {
        didSet {
            playerTableView.reloadData()
        }
    }
    
    @IBAction func leaveGameButton(sender: AnyObject) {
        FIRUser.deleteUserFromSession(accessCodeLabel.text!)
    }
    
    @IBAction func startGameButton(sender: AnyObject) {
        FIRSession.startSession(accessCodeLabel.text!)
        self.performSegueWithIdentifier("goToGameStart", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Retrieves the session code */
        FIRUser.retrieveUserInfo("session", callback: { (sessionCode) in
            self.accessCodeLabel.text = sessionCode
            
            /* Must wait until the VC knows the accessCode before we can access the player information */
            FIRSession.observeSessionInfo(sessionCode!, addPlayerCallback: self.handleAddedPlayer, deletePlayerCallback: self.handleDeletedPlayer, gameChangedStateCallback: self.handleGameStateChange)
        })
            
        playerTableView.delegate = self
        playerTableView.dataSource = self
    }
    
    func handleAddedPlayer(addedPlayer:String) {
        playersInLobby.append(addedPlayer)
    }
    
    func handleDeletedPlayer(deletedPlayer: String) {
        let indexOfDeletedPlayer = playersInLobby.indexOf(deletedPlayer)!
        playersInLobby.removeAtIndex(indexOfDeletedPlayer)
    }
    
    func handleGameStateChange(inProgress: Bool) {
        if(inProgress) {
            self.performSegueWithIdentifier("goToGameStart", sender: self)
            
        }
        else {
            //Game ended
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersInLobby.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.playerTableView.dequeueReusableCellWithIdentifier("playerCell", forIndexPath: indexPath) as! PlayerCell
        
        cell.playerNameLabel.text = playersInLobby[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header_text
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return number_of_sections
    }
 
}
