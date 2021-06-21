//
//  SideBarCell.swift
//  STEP
//
//  Created by apple on 04/06/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SideBarCell: UITableViewCell {
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
