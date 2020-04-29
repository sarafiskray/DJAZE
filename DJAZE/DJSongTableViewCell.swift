//
//  DJSongTableViewCell.swift
//  DJAZE
//
//  Created by Bo Warren on 4/24/20.
//  Copyright © 2020 DJAZE. All rights reserved.
//

import UIKit

protocol DJSongCellDelegate: NSObjectProtocol {
    func getDownVoteCount(index: Int) -> Int
    func getUpVoteCount(index: Int) -> Int
}

class DJSongTableViewCell: UITableViewCell {

    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var downVoteCountLabel: UILabel!
    @IBOutlet weak var upVoteCountLabel: UILabel!
    
    
    
    var delegate: DJSongCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
