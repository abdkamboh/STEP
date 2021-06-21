//
//  DetailListCell.swift
//  STEP
//
//  Created by apple on 21/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class DetailListCell: UITableViewCell {
    @IBOutlet weak var lineView : UIView!
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var subtitle : UILabel!
    @IBOutlet weak var startButton : UIButton!
    @IBOutlet weak var stopButton : UIButton!
    @IBOutlet weak var topView : UIView!
    @IBOutlet weak var bottomView : UIView!
    @IBOutlet weak var startView : UIView!
    @IBOutlet weak var stopView : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
