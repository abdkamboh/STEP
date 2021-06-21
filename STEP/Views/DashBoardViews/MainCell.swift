//
//  MainCell.swift
//  STEP
//
//  Created by apple on 20/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {

    @IBOutlet weak var date : UILabel!
    @IBOutlet weak var day : UILabel!
    @IBOutlet weak var dayNo : UILabel!
    @IBOutlet weak var line : UIView!
    @IBOutlet weak var stackView : UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setColor(color:UIColor){
        self.date.textColor = color
        self.day.textColor =  color
        self.dayNo.textColor =  color
    }
    func setValues( date: String, day : String, dayNo:String){
        self.date.text = date
        self.day.text =  day
        self.dayNo.text =  dayNo
    }
}
