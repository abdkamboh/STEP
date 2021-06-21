//
//  SideMenuCell.swift
//  STEP
//
//  Created by apple on 07/06/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var MenuTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


