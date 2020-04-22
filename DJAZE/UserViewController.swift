//
//  UserViewController.swift
//  DJAZE
//
//  Created by Saraf Ray on 4/21/20.
//  Copyright © 2020 DJAZE. All rights reserved.
//

import UIKit
import SpotifyKit

class UserViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var songs = ["Peta", "Gorgeous", "Many Men"]
    var artists = ["Roddy Ricch", "Kanye West", "50Cent"]
    
    @IBOutlet weak var nowPlayingSongLabel: UILabel!
    @IBOutlet weak var nowPlayingArtistLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell
        cell.songLabel.text = songs[indexPath.row]
        cell.artistLabel.text = artists[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    @IBAction func nowPlayingDislikeButton(_ sender: Any) {
    }
    @IBAction func nowPlayingLikeButton(_ sender: Any) {
    }
    
    
}
