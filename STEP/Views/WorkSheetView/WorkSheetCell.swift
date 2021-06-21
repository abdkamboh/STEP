//
//  WorkSheetCell.swift
//  STEP
//
//  Created by apple on 22/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class WorkSheetCell: UITableViewCell {
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var subtitle : UILabel!
    @IBOutlet weak var countLbl : UILabel!
    @IBOutlet weak var testButton : UIButton!
    @IBOutlet weak var disImage : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
