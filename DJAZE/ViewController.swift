//
//  ViewController.swift
//  DJAZE
//
//  Created by Bo Warren on 4/21/20.
//  Copyright © 2020 DJAZE. All rights reserved.
//

import UIKit
import SpotifyKit

class ViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet var searchTermField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //customizeProfilePictureView()
        
        // Authorize our app for the Spotify account if there is no token
        // This opens a browser window from which the user can authenticate into his account
        spotifyManager.authorize()
        
        //loadUser()
    }
    
    
    @IBAction func searchButton(_ sender: Any) {
        //get text from search box
        var searchTerm = searchTermField.text!
        //pass to spotifyManager
        spotifyManager.find(SpotifyTrack.self, searchTerm) { tracks in
            // Tracks is a [SpotifyTrack] array
            for track in tracks {
                print("URI:    \(track.uri), "         +
                      "Name:   \(track.name), "        +
                      "Artist: \(track.artist.name), ")
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func search(_ searchTerm: String) {
        spotifyManager.find(SpotifyTrack.self, searchTerm) { tracks in
        // Tracks is a [SpotifyTrack] array
        for track in tracks {
            print("URI:    \(track.uri), "         +
                  "Name:   \(track.name), "        +
                  "Artist: \(track.artist.name) " )
            }
        }
    }
    
    
    

}

