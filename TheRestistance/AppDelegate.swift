//
//  AppDelegate.swift
//  TheRestistance
//
//  Created by Alan Gao on 8/8/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FIRApp.configure()
        
        /* Prevents user's phone from automatically sleeping. Sleeping disconnects the user
           from the database servers, and so will cause connectivity problems if it's automatically triggered */
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        /* If the user terminated the app without clicking 'leave game', he/she will
           be brought back to their old session */
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let previousSession = userDefaults.valueForKey("sessionCode") {
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            
            
            
            let gameLobbyVC = storyboard.instantiateViewControllerWithIdentifier("GameLobbyViewController") as! GameLobbyViewController
            //gameLobbyVC.accessCodeLabel.text = String(previousSession)
            self.window?.rootViewController = gameLobbyVC
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:
        
    }

 
}

