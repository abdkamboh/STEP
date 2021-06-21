//
//  ResourceCell.swift
//  STEP
//
//  Created by apple on 09/06/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ResourceCell: UITableViewCell {
    var link : URL!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subject : UILabel!
    @IBOutlet weak var lineView : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func Download(_ sender: UIButton){
        if link != nil{
         UIApplication.shared.open(link)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
