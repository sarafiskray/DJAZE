//
//  UserViewController.swift
//  DJAZE
//
//  Created by Saraf Ray on 4/21/20.
//  Copyright © 2020 DJAZE. All rights reserved.
//

import UIKit
import SpotifyKit
import Firebase


class UserViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, SongCellDelegate {
    
    let db=Firestore.firestore()
    var autoid=""
   
    
    
    
    
    
    
    var songs = [Song(title: "Peta", artist: "Roddy Ricch", upVoteCount: 0, downVoteCount: 0), Song(title: "Gorgeous", artist: "Kanye West", upVoteCount: 0, downVoteCount: 0), Song(title: "Many Men", artist: "50Cent", upVoteCount: 0, downVoteCount: 0)]
    
    lazy var sortedSongs = songs.sorted(by: {$0.aggVote > $1.aggVote})
    
    var currentSong = Song(title: "", artist: "", upVoteCount: 0, downVoteCount: 0)
    
    //var ref: DatabaseReference!
    var searchInfo: [songInfo] = []
    
    
    var songCounter=0
    var song="song"
    
    
    
    @IBOutlet weak var searchTermTextField: UITextField!
    @IBOutlet weak var nowPlayingSongLabel: UILabel!
    @IBOutlet weak var nowPlayingArtistLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(getCurrentSong())
        nowPlayingSongLabel.text = currentSong.title
        nowPlayingArtistLabel.text = currentSong.artist

        
    }
    
    func getCurrentSong() -> (title: String, artist: String) {
        var nowPlayingSongTitle = ""
        var nowPlayingArtist = ""
        db.collection("SongsPlayed").order(by: "Counter", descending: true).limit(to: 1)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //print("\(document.data()["Artist"]!)")
                        //print("\(document.data()["SongName"]!)")
                        let currentTitle = document.data()["Artist"]! as! String
                        let currentArtist = document.data()["SongName"]! as! String
                        nowPlayingSongTitle = currentTitle
                        nowPlayingArtist = currentArtist
                        print(nowPlayingSongTitle)
                        print(nowPlayingArtist)
                        //self.currentSong = Song(title: currentTitle, artist: currentArtist, upVoteCount: 0, downVoteCount: 0)
                        //print(currentTitle)
                        //print(currentArtist)
                    }
                }
        }
       return (nowPlayingSongTitle, nowPlayingArtist)
    }
    
    // vote functions for requested songs
    func voteUp(index: Int) {
        songs[index].voteUp()
        //sortedSongs = songs.sorted(by: {$0.aggVote > $1.aggVote})
    }
    
    func voteDown(index: Int) {
        songs[index].voteDown()
        //sortedSongs = songs.sorted(by: {$0.aggVote > $1.aggVote})
    }
    
    func getUpVoteCount(index: Int) -> Int {
        return songs[index].upVoteCount
    }

    func getDownVoteCount(index: Int) -> Int {
        return songs[index].downVoteCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell
        cell.songLabel.text = sortedSongs[indexPath.row].title
        cell.artistLabel.text = sortedSongs[indexPath.row].artist
        cell.downVoteCountLabel.text = "\(sortedSongs[indexPath.row].downVoteCount)"
        cell.upVoteCountLabel.text = "\(sortedSongs[indexPath.row].upVoteCount)"
        cell.delegate = self
        cell.tag = indexPath.row
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
    
    func sendToDb(_ name: String, _ artist: String)
    {
        var songNum=song+String(songCounter) //song0 song1 song2 song3
        songCounter+=1
        autoid=String(songCounter)
        
        db.collection("Songs").document(autoid).setData( ["SongNum":autoid,"Artist" : artist,"SongName":name], merge:true)
        
    }
    
    
    @IBAction func refreshDb(_ sender: Any) {
        
    }
    
    
    func search(_ searchTerm: String)
    {
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
