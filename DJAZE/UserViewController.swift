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
    
    var currentSongTitle = ""
    var currentSongArtist = ""
    
    
    var songs = [Song(title: "Peta", artist: "Roddy Ricch", upVoteCount: 0, downVoteCount: 0), Song(title: "Gorgeous", artist: "Kanye West", upVoteCount: 0, downVoteCount: 0), Song(title: "Many Men", artist: "50Cent", upVoteCount: 0, downVoteCount: 0)]
    
    lazy var sortedSongs = songs.sorted(by: {$0.aggVote > $1.aggVote})
    
    var currentSong = Song(title: "Bop", artist: "DaBaby", upVoteCount: 0, downVoteCount: 0)
    
    //var ref: DatabaseReference!
    var searchInfo: [songInfo] = []
    
    
    var songCounter=0
    var song="song"
    
    
    
    @IBOutlet weak var searchTermTextField: UITextField!
    @IBOutlet weak var nowPlayingSongLabel: UILabel!
    @IBOutlet weak var nowPlayingArtistLabel: UILabel!
    @IBOutlet weak var requestedSongsTableView: UITableView!
    
    
    @IBOutlet var firstResultButton: UIButton!
    @IBOutlet var secondResultButton: UIButton!
    @IBOutlet var thirdResultButton: UIButton!
    
    
    @IBAction func selectFirstResult(_ sender: Any) {
        sendToDb(searchInfo[0].name, searchInfo[0].artist)
    }
    
    
    @IBAction func selectSecondResult(_ sender: Any) {
        sendToDb(searchInfo[1].name, searchInfo[1].artist)

    }
    
    
    @IBAction func selectThirdResult(_ sender: Any) {
        sendToDb(searchInfo[2].name, searchInfo[2].artist)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrentSong()
        //nowPlayingSongLabel.text = currentSong.title
        //nowPlayingArtistLabel.text = currentSong.artist
        sortSongs()
        
    }
    
    func updateCurrentSongLabel(_ title: String, _ artist: String) {
        nowPlayingSongLabel.text = title
        nowPlayingArtistLabel.text = artist
    }
    
    func getCurrentSong() {
        db.collection("SongsPlayed").order(by: "Counter", descending: true).limit(to: 1)
            .getDocuments()  { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //print("\(document.data()["Artist"]!)")
                        //print("\(document.data()["SongName"]!)")
                        self.currentSongTitle = document.data()["Artist"]! as! String
                        self.currentSongArtist = document.data()["SongName"]! as! String
                        self.updateCurrentSongLabel(self.currentSongTitle, self.currentSongArtist)
                        //self.currentSong = Song(title: currentTitle, artist: currentArtist, upVoteCount: 0, downVoteCount: 0)
                    }
                }
        }
    }
    
    
    func sortSongs() {
        sortedSongs = songs.sorted(by: {$0.aggVote > $1.aggVote})
    }
    
    
    // vote functions for requested songs
    func voteUp(index: Int) {
        songs[index].voteUp()
        sortSongs()
        self.requestedSongsTableView.reloadData()
    }
    
    func voteDown(index: Int) {
        songs[index].voteDown()
        sortSongs()
        requestedSongsTableView.reloadData()
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
//        spotifyManager.isSaved(track: SpotifyTrack.self, completionHandler: spotifyManager.save(track: SpotifyTrack.self, completionHandler: print("error")))
    }
    
    func sendToDb(_ name: String, _ artist: String)
    {
        var songNum=song+String(songCounter) //song0 song1 song2 song3
        songCounter+=1
        autoid=String(songCounter)
        
        db.collection("songsRequested").document(autoid).setData( ["SongNum":autoid,"Artist" : artist,"SongName":name], merge:true)
        
    }
    
    func updateButtons(_ buttonInfo: [songInfo]) {
        firstResultButton.setTitle(buttonInfo[0].name + ", " + buttonInfo[0].artist, for: [])
        secondResultButton.setTitle(buttonInfo[1].name + ", " + buttonInfo[1].artist, for: [])
        thirdResultButton.setTitle(buttonInfo[2].name + ", " + buttonInfo[2].artist, for: [])
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
                if (count == numSongstoReturn) {
                    //print(searchInfo[0].name)
                    self.updateButtons(self.searchInfo)
                    break
                }
            }
        }
    }
    
    
}
