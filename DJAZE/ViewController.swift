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
    
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var userNameLabel:      UILabel!
    @IBOutlet weak var mailLabel:          UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeProfilePictureView()
        
        // Authorize our app for the Spotify account if there is no token
        // This opens a browser window from which the user can authenticate into his account
        spotifyManager.authorize()
        
        loadUser()
    }
    
    
    @IBAction func searchButton(_ sender: Any) {
        spotifyManager.find(SpotifyTrack.self, "yo") { tracks in
            // Tracks is a [SpotifyTrack] array
            for track in tracks {
                print("URI:    \(track.uri), "         +
                      "Name:   \(track.name), "        +
                      "Artist: \(track.artist.name), ")
            }
        }
    }
    
    func customizeProfilePictureView() {
        // Add a circular layer around profile picture
        profilePictureView.layer.cornerRadius = profilePictureView.frame.size.width / 2
        profilePictureView.clipsToBounds      = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Load UI
    
    func loadUser() {
        spotifyManager.myProfile { [weak self] profile in
            // Set user name
            self?.userNameLabel.text = profile.name
            
            // Set mail
            self?.mailLabel.text = profile.email ?? ""
            
            // Set image
            if let imageURL = URL(string: profile.artUri) {
                self?.profilePictureView.download(from: imageURL)
            }
        }
    }
    
    

}

