//
//  AnswerCell.swift
//  STEP
//
//  Created by apple on 27/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
class TextCell: UITableViewCell {

    @IBOutlet weak var heading : UILabel!
    @IBOutlet weak var discription : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class VideoCell: UITableViewCell {

    
    @IBOutlet weak var youTubeView : YTPlayerView!
    @IBOutlet weak var height: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
