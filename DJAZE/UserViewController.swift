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
    
    var songs = [Song(title: "Peta", artist: "Roddy Ricch", upVoteCount: 6, downVoteCount: 15), Song(title: "Gorgeous", artist: "Kanye West", upVoteCount: 20, downVoteCount: 10), Song(title: "Many Men", artist: "50Cent", upVoteCount: 5, downVoteCount: 2)]
    
    lazy var sortedSongs = songs.sorted(by: {$0.aggVote > $1.aggVote})
    
    var currentSong = Song(title: "Bop", artist: "DaBaby", upVoteCount: 0, downVoteCount: 0)
    

    var searchInfo: [songInfo] = []
    
    var songCounter=0
    var song="song"
    
    
    
    @IBOutlet weak var searchTermTextField: UITextField!
    @IBOutlet weak var nowPlayingSongLabel: UILabel!
    @IBOutlet weak var nowPlayingArtistLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nowPlayingSongLabel.text = currentSong.title
        nowPlayingArtistLabel.text = currentSong.artist
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell
        cell.songLabel.text = sortedSongs[indexPath.row].title
        cell.artistLabel.text = sortedSongs[indexPath.row].artist
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    struct songInfo : Hashable {
        var uri: String
        var name: String
        var artist: String
    }
    
    @IBAction func searchButton(_ sender: Any) {
        let searchTerm = searchTermTextField.text!
        
        search(searchTerm)
    }
    @IBAction func nowPlayingDislikeButton(_ sender: Any) {
        currentSong.voteDown()
    }
    @IBAction func nowPlayingLikeButton(_ sender: Any) {
        currentSong.voteUp()
    }
    @IBAction func addButton(_ sender: Any) {
//        spotifyManager.isSaved(trackId: "Peta" { isSaved; in spotifyManager.save(trackId: "Peta", completionHandler: <#T##(Bool) -> Void#>)}
        print(currentSong.aggVote)

    }
    
    func search(_ searchTerm: String) {
        //var searchInfo: [songInfo] = []
        searchInfo = []
        let numSongstoReturn = 3
        var count = 0
        spotifyManager.find(SpotifyTrack.self, searchTerm) {
            tracks in
                for track in tracks {
                    var searchResult = songInfo(uri: track.uri, name: track.name, artist: track.artist.name)
                    self.searchInfo.append(searchResult)
                    count += 1
//                    self.songs.append(Song(title: track.name, artist: track.artist.name, upVoteCount: 0, downVoteCount: 0))
                 
            }
            
            
        }
    }
    
    
}
