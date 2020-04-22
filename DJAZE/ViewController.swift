//
//  ViewController.swift
//  DJAZE
//
//  Created by Bo Warren on 4/21/20.
//  Copyright © 2020 DJAZE. All rights reserved.
//

import UIKit
import SpotifyKit
import Firebase

class ViewController: UIViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //customizeProfilePictureView()
        
        // Authorize our app for the Spotify account if there is no token
        // This opens a browser window from which the user can authenticate into his account
        spotifyManager.authorize()
        //loadUser()
    }
    
    @IBAction func DJSegueButton(_ sender: UIButton) {
        performSegue(withIdentifier: "DJSegue", sender: self)
    }
    
    
    @IBAction func userSegueButton(_ sender: Any) {
        performSegue(withIdentifier: "userSegue", sender: self)
    }
    
    
    

}

