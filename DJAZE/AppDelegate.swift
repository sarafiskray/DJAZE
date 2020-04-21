//
//  AppDelegate.swift
//  DJAZE
//
//  Created by Bo Warren on 4/21/20.
//  Copyright © 2020 DJAZE. All rights reserved.
//

import UIKit

// Import SpotifyKit iOS library
import SpotifyKit
import Firebase

// MARK: SpotifyKit initialization

// The Spotify developer application object
// Fill this with the data from the app you've set up on Spotify developer page
fileprivate let application = SpotifyManager.SpotifyDeveloperApplication(
    clientId:     "e9812beae3e54142b0d0696f96dcd92f",
    clientSecret: "28b96ee81927452eba3d1a516b307547",
    redirectUri:  "djaze4://callback"
)

// The SpotifyKit helper object that will allow you to perform the queries
let spotifyManager = SpotifyManager(with: application)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // MARK: URL event handling
    
    /**
     After sending 'swiftify.authorize()' command,
     our application receives an URL starting with the "redirect uri" we've set up
     in Spotify Developer page and added to our app's Info.plist under "URL types" -> "URL schemes".
     This URI contains the token access code which grants the privileges needed for performing Spotify queries.
     Here we catch the URI as it is passed to our app, retrieve the token code and send it
     to Swifify, which will generate the code and save it in Keychain for persistency
     */
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        spotifyManager.saveToken(from: url)
        
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }

}

