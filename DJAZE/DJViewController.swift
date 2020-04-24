//
//  DJViewController.swift
//  DJAZE
//

import UIKit
import SpotifyKit
import Firebase

class DJViewController: UIViewController {
    //global
    var searchInfo: [songInfo] = []
    //firestore
    let db=Firestore.firestore()
    var songCounter=0
    var song="song"
    
    // MARK: Outlets
    @IBOutlet var searchTermField: UITextField!
    
    @IBOutlet var firstResultButton: UIButton!
    @IBOutlet var secondResultButton: UIButton!
    @IBOutlet var thirdResultButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
    }
    @IBAction func selectSecondResult(_ sender: Any)
    {
        sendToDb(searchInfo[1].name, searchInfo[1].artist)

    }
    
    @IBAction func selectThirdResult(_ sender: Any)
    {
        sendToDb(searchInfo[2].name, searchInfo[2].artist)

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
    
        
    

}

