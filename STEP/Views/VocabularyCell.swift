//
//  VocabularyCell.swift
//  STEP
//
//  Created by apple on 09/06/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class VocabularyCell: UITableViewCell {
    @IBOutlet weak var number:UILabel!
    @IBOutlet weak var word:UILabel!
    @IBOutlet weak var  view: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.view.layer.masksToBounds = false
//        self.view.layer.shadowColor = UIColor.black.cgColor
//        self.view.layer.shadowOffset = CGSize(width: 1, height: 1)
//        self.view.layer.shadowOpacity = 0.5
//        self.view.layer.shadowRadius = 2
//        self.view.layer.cornerRadius = 5
//         self.view.layer.shadowPath = UIBezierPath(rect:  self.view.bounds).cgPath
//        self.view.layer.shouldRasterize = true
//         self.view.layer.rasterizationScale = UIScreen.main.scale
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
