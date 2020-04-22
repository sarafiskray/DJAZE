//
//  DJViewController.swift
//  DJAZE
//

import UIKit
import SpotifyKit

class DJViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet var searchTermField: UITextField!
    
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
    
    
    func search(_ searchTerm: String) {
        var searchInfo: [songInfo] = []
        let numSongstoReturn = 3
        var count = 0
        spotifyManager.find(SpotifyTrack.self, searchTerm) {
            tracks in
                for track in tracks {
                //print("URI:    \(track.uri), "         +
                //    "Name:   \(track.name), "        +
                //    "Artist: \(track.artist.name) " )
                    var searchResult = songInfo(uri: track.uri, name: track.name, artist: track.artist.name)
                    searchInfo.append(searchResult)
                    count += 1
                    if (count == numSongstoReturn) {
                        //print(searchInfo)
                        break
                    }
                }
            }
        }
    
        
    

}

