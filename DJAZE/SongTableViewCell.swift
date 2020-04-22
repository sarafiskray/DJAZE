//
//  SongTableViewCell.swift
//  DJAZE
//
//  Created by Bo Warren on 4/22/20.
//  Copyright © 2020 DJAZE. All rights reserved.
//

import UIKit

protocol SongCellDelegate: NSObjectProtocol {
    func voteUp(index: Int)
    func voteDown(index: Int)
}

class SongTableViewCell: UITableViewCell {
    
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    var delegate: SongCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func dislikeButton(_ sender: Any) {
        
    }
    @IBAction func likeButton(_ sender: Any) {
    }
    

}
