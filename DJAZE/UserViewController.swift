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
    
    var first=true
    var backForwardSong:[String]=[]
    var backForwardArtist:[String]=[]
    var carouselCounter=1
    var carouselPlace=1
    var displaySong=""
    var displayArtist=""
    
    var requestedSongs: [Song] = []
    var songReqTitle = ""
    var songReqArtist = ""
    var songReq : Song = Song(title: "", artist: "", upVoteCount: 0, downVoteCount: 0)
    
    let db=Firestore.firestore()
    var autoid=""
    
    var currentSongID = ""
    var currentSongTitle = ""
    var currentSongArtist = ""
    
    var songSaveCheck = false
    var searched = false
    
    
//    var songs = [Song(title: "Peta", artist: "Roddy Ricch", upVoteCount: 0, downVoteCount: 0), Song(title: "Gorgeous", artist: "Kanye West", upVoteCount: 0, downVoteCount: 0), Song(title: "Many Men", artist: "50Cent", upVoteCount: 0, downVoteCount: 0)]
    
    lazy var sortedSongs = requestedSongs.sorted(by: {$0.aggVote > $1.aggVote})
    
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
        if (searched == true) {
            sendToDb(searchInfo[0].name, searchInfo[0].artist)
            songReq = Song(title: searchInfo[0].name, artist: searchInfo[0].artist, upVoteCount: 0, downVoteCount: 0)
            addToReqs(songReq)
            requestedSongsTableView.reloadData()
        } else {
            print("you need to do a search first")
        }
    }
    
    
    @IBAction func selectSecondResult(_ sender: Any) {
        if (searched == true) {
            sendToDb(searchInfo[1].name, searchInfo[1].artist)
            songReq = Song(title: searchInfo[1].name, artist: searchInfo[1].artist, upVoteCount: 0, downVoteCount: 0)
            addToReqs(songReq)
            requestedSongsTableView.reloadData()
        } else {
            print("you need to do a search first")
        }
    }
    
    
    @IBAction func selectThirdResult(_ sender: Any) {
        if (searched == true) {
            sendToDb(searchInfo[2].name, searchInfo[2].artist)
            songReq = Song(title: searchInfo[2].name, artist: searchInfo[2].artist, upVoteCount: 0, downVoteCount: 0)
            addToReqs(songReq)
            requestedSongsTableView.reloadData()
        } else {
            print("you need to do a search first")
        }
    }
    
    
    @IBAction func back(_ sender: Any)
    {
        if carouselPlace-1>=0
        {
            if first==true && carouselPlace-1 != 0
            {
                self.carouselPlace-=2
                self.first=false
            }
            else{
                self.carouselPlace-=1
            }
            
            print("Carousel Place: ",carouselPlace+1)
            print("Total Songs",carouselCounter-1)
            nowPlayingSongLabel.text = self.backForwardSong[self.carouselPlace]
            nowPlayingArtistLabel.text = self.backForwardArtist[self.carouselPlace]
        }
    }
    
    @IBAction func forward(_ sender: Any)
    {
        if carouselPlace+2<carouselCounter
        {
            self.carouselPlace+=1
            print("Carousel Place: ", carouselPlace+1)
            print("Total Songs:",carouselCounter-1)
            nowPlayingSongLabel.text = self.backForwardSong[self.carouselPlace]
            nowPlayingArtistLabel.text = self.backForwardArtist[self.carouselPlace]
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.first=true
        getCurrentSong()
        getRequestedSongs()
        populate()
        //nowPlayingSongLabel.text = currentSong.title
        //nowPlayingArtistLabel.text = currentSong.artist
        //sortSongs()
        
    }
    
    func updateCurrentSongLabel(_ title: String, _ artist: String) {
        nowPlayingSongLabel.text = artist
        nowPlayingArtistLabel.text = title
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
                        self.currentSongID = document.data()["Track ID"]! as! String
                        self.updateCurrentSongLabel(self.currentSongTitle, self.currentSongArtist)
                        //self.currentSong = Song(title: currentTitle, artist: currentArtist, upVoteCount: 0, downVoteCount: 0)
                    }
                }
        }
    }
    
    
//    func sortSongs() {
//        sortedSongs = requestedSongs.sorted(by: {$0.aggVote > $1.aggVote})
//    }
    
    
    // vote functions for requested songs
    func voteUp(index: Int) {
        requestedSongs[index].voteUp()
        //sortSongs()
        //send to db
        let documentNum : String = String(index + 1)
        let reqRef = db.collection("songsRequested").document(documentNum)
        reqRef.updateData(["upvotes" : FieldValue.increment(Int64(1))
            ])
        self.requestedSongsTableView.reloadData()
        
    }
    
    func voteDown(index: Int) {
        requestedSongs[index].voteDown()
        //sortSongs()
        //send to db
        let documentNum : String = String(index + 1)
        let reqRef = db.collection("songsRequested").document(documentNum)
        reqRef.updateData(["downvotes" : FieldValue.increment(Int64(1))
            ])
        requestedSongsTableView.reloadData()
        
    }
    
    func getUpVoteCount(index: Int) -> Int {
        return requestedSongs[index].upVoteCount
    }

    func getDownVoteCount(index: Int) -> Int {
        return requestedSongs[index].downVoteCount
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestedSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell
        cell.songLabel.text = requestedSongs[indexPath.row].title
        cell.artistLabel.text = requestedSongs[indexPath.row].artist
        cell.downVoteCountLabel.text = "\(requestedSongs[indexPath.row].downVoteCount)"
        cell.upVoteCountLabel.text = "\(requestedSongs[indexPath.row].upVoteCount)"
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
        searched = true
        search(searchTerm)
    }
    @IBAction func nowPlayingDislikeButton(_ sender: Any) {
        currentSong.voteDown()
    }
    @IBAction func nowPlayingLikeButton(_ sender: Any) {
        currentSong.voteUp()
    }
    @IBAction func addButton(_ sender: Any) {
        spotifyManager.isSaved(trackId: currentSongID) { _ in
            self.songSaveCheck = true
        }
        if self.songSaveCheck == false {
            spotifyManager.save(trackId: currentSongID) { _ in
            }
        }
    }
    
    func sendToDb(_ name: String, _ artist: String)
    {
        var songNum=song+String(songCounter) //song0 song1 song2 song3
        songCounter+=1
        autoid=String(songCounter)
        
        db.collection("songsRequested").document(autoid).setData( ["SongNum":autoid, "Artist":artist, "SongName":name, "upvotes":0, "downvotes":0], merge:true)
        
    }
    
    func updateButtons(_ buttonInfo: [songInfo]) {
        firstResultButton.setTitle(buttonInfo[0].name + ", " + buttonInfo[0].artist, for: [])
        secondResultButton.setTitle(buttonInfo[1].name + ", " + buttonInfo[1].artist, for: [])
        thirdResultButton.setTitle(buttonInfo[2].name + ", " + buttonInfo[2].artist, for: [])
    }
    
    func appendSong(_ song:String,_ artist:String, _ counter:Int)
    {
        self.backForwardArtist.append(artist)
        self.backForwardSong.append(song)
        self.carouselCounter=counter
        self.carouselPlace=self.carouselCounter
    }


    func populate(){
        db.collection("SongsPlayed").order(by: "Counter", descending:false)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        self.displaySong=document.data()["SongName"]! as! String

                        self.displayArtist=document.data()["Artist"]! as! String
                            
                        
                        
                        self.appendSong(self.displaySong, self.displayArtist, self.carouselCounter)
                        self.carouselCounter+=1
                    }
                }
        }
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
    
    func addToReqs(_ songreq: Song) {
        requestedSongs.append(songreq)
        //sortedSongs = requestedSongs.sorted(by: {$0.aggVote > $1.aggVote})
        
    }
    
    //query for getting requested songs
    func getRequestedSongs() {
        requestedSongs.removeAll()
        let requestsRef = db.collection("songsRequested")
        requestsRef.getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                //print("\(document.documentID) => \(document.data())")
                self.songReqTitle = document.data()["SongName"] as! String
                self.songReqArtist = document.data()["Artist"] as! String
                self.songReq = Song(title: self.songReqTitle, artist: self.songReqArtist, upVoteCount: 0, downVoteCount: 0)
                self.addToReqs(self.songReq)
            }
            self.sortedSongs = self.requestedSongs.sorted(by: {$0.aggVote > $1.aggVote})
            self.requestedSongsTableView.reloadData()
        }
    
    }
    
    
}
}
