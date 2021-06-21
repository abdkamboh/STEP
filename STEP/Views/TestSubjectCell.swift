//
//  WebCell.swift
//  STEP
//
//  Created by apple on 30/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import WebKit
class TestSubjectCell: UICollectionViewCell {

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var subjectImage: UIImageView!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var height: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
class WebCell: UITableViewCell {


    @IBOutlet weak var viewWeb: UIView!
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
