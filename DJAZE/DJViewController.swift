//
//  DJViewController.swift
//  DJAZE
//

import UIKit
import SpotifyKit
import Firebase

class DJViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DJSongCellDelegate {
    
    //global
    var searchInfo: [songInfo] = []
    var requestedSongs: [Song] = []
    var songReqTitle = ""
    var songReqArtist = ""
    var songReq : Song = Song(title: "", artist: "", upVoteCount: 0, downVoteCount: 0)
    //firestore
    let db=Firestore.firestore()
    var songCounter=0
    var song="song"
    
    
    // hard coded songs
//    var songs = [Song(title: "Peta", artist: "Roddy Ricch", upVoteCount: 0, downVoteCount: 0), Song(title: "Gorgeous", artist: "Kanye West", upVoteCount: 0, downVoteCount: 0), Song(title: "Many Men", artist: "50Cent", upVoteCount: 0, downVoteCount: 0)]
    
    lazy var sortedSongs = requestedSongs.sorted(by: {$0.aggVote > $1.aggVote})
    
    
    @IBOutlet var searchTermField: UITextField!
    
    @IBOutlet weak var nowPlayingSongLabel: UILabel!
    @IBOutlet weak var nowPlayingArtistLabel: UILabel!
    @IBOutlet weak var nowPlayingDownVoteCount: UILabel!
    @IBOutlet weak var nowPlayingUpVoteCount: UILabel!
    
    @IBOutlet weak var djRequestedSongsTableView: UITableView!
    
    
    
    @IBOutlet var firstResultButton: UIButton!
    @IBOutlet var secondResultButton: UIButton!
    @IBOutlet var thirdResultButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRequestedSongs()
        print(requestedSongs)
        
    }
    
    func updateCurrentSongLabel(_ title: String, _ artist: String) {
        nowPlayingSongLabel.text = title
        nowPlayingArtistLabel.text = artist
    }
    
    //search button
    
    @IBAction func searchButton(_ sender: Any) {
        
        var searchTerm = searchTermField.text!
        
        search(searchTerm)
    }
    
    //adds songname and artist to db
    //var ref: DatabaseReference!
    //ref = Database.database().reference()

    //@IBAction func playSong()
    //{
    //    let song="song"
    //    var songNum=song+String(counter)
    //    counter+=1
        
    //    self.ref.child("Songs/\(songNum)/Artist").setValue(artist)
    //    self.ref.child("Songs/\(songNum)/SongName").setValue(songName)
    //}
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    struct songInfo : Hashable {
        var uri: String
        var name: String
        var artist: String
    }
    
    
    @IBAction func selectFirstResult(_ sender: Any)
    {
        sendToDb(searchInfo[0].name, searchInfo[0].artist)
        updateCurrentSongLabel(searchInfo[0].name, searchInfo[0].artist)
    }
    @IBAction func selectSecondResult(_ sender: Any)
    {
        sendToDb(searchInfo[1].name, searchInfo[1].artist)
        updateCurrentSongLabel(searchInfo[1].name, searchInfo[1].artist)

    }
    
    @IBAction func selectThirdResult(_ sender: Any)
    {
        sendToDb(searchInfo[2].name, searchInfo[2].artist)
        updateCurrentSongLabel(searchInfo[2].name, searchInfo[2].artist)

    }
    
    func sendToDb(_ name: String, _ artist: String)
    {
        //ref = Database.database().reference()
        var songNum=song+String(songCounter) //song0 song1 song2 song3
        songCounter+=1
        var autoid=String(songCounter)
        
        db.collection("SongsPlayed").document(autoid).setData( ["Artist" : artist,
                                                                "SongName" : name,
                                                                "Counter" : songCounter], merge:true)
        //self.ref.child("Songs/\(songNum)/Artist").setValue(artist)
        //self.ref.child("Songs/\(songNum)/SongName").setValue(name)
        //self.ref.child("Songs/\(songNum)/Counter").setValue(songCounter)

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
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestedSongCell", for: indexPath) as! DJSongTableViewCell
        cell.songLabel.text = sortedSongs[indexPath.row].title
        cell.artistLabel.text = sortedSongs[indexPath.row].artist
        cell.downVoteCountLabel.text = "\(sortedSongs[indexPath.row].downVoteCount)"
        cell.upVoteCountLabel.text = "\(sortedSongs[indexPath.row].upVoteCount)"
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func getDownVoteCount(index: Int) -> Int {
        return 0
    }
    
    func getUpVoteCount(index: Int) -> Int {
        return 0
    }

    
    
    
    func addToReqs(_ songreq: Song) {
        requestedSongs.append(songreq)
    }
    
    //query for getting requested songs
    func getRequestedSongs() {
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
            self.djRequestedSongsTableView.reloadData()
        }
    
    }
}

}
