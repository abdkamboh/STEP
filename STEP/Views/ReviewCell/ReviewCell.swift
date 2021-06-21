//
//  ReviewCell.swift
//  STEP
//
//  Created by Abdur Rehman on 04/06/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    @IBOutlet weak var questionNo : UILabel!
    @IBOutlet weak var subject : UILabel!
    @IBOutlet weak var selectedOption : UILabel!
    @IBOutlet weak var lineView:UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
