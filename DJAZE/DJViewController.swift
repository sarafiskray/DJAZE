//
//  DJViewController.swift
//  DJAZE
//

import UIKit
import SpotifyKit
import Firebase

class DJViewController: UIViewController {
    var ref: DatabaseReference!
    // MARK: Outlets
    var songCounter=0
    var song="song"
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
        
    }
    @IBAction func selectSecondResult(_ sender: Any)
    {
        
    }
    
    @IBAction func selectThirdResult(_ sender: Any)
    {
    }
    
    func sendToDb(_ buttonInfo: songInfo)
    {
        ref = Database.database().reference()
        var songNum=song+String(songCounter) //song0 song1 song2 song3
        songCounter+=1
        
        self.ref.child("Songs/\(songNum)/Artist").setValue(buttonInfo.artist)
        self.ref.child("Songs/\(songNum)/SongName").setValue(buttonInfo.name)
    }
    
    func updateButtons(_ buttonInfo: [songInfo]) {
        firstResultButton.setTitle(buttonInfo[0].name + buttonInfo[0].artist, for: [])
        secondResultButton.setTitle(buttonInfo[1].name + buttonInfo[1].artist, for: [])
        thirdResultButton.setTitle(buttonInfo[2].name + buttonInfo[2].artist, for: [])
    }
    
    func search(_ searchTerm: String) {
        var searchInfo: [songInfo] = []
        let numSongstoReturn = 3
        var count = 0
        spotifyManager.find(SpotifyTrack.self, searchTerm) {
            tracks in
                for track in tracks {
                    var searchResult = songInfo(uri: track.uri, name: track.name, artist: track.artist.name)
                    searchInfo.append(searchResult)
                    count += 1
                    if (count == numSongstoReturn) {
                        //print(searchInfo[0].name)
                        self.updateButtons(searchInfo)
                        break
                    }
                }
            }
        }
    
        
    

}

