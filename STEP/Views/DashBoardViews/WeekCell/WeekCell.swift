//
//  WeekCell.swift
//  STEP
//
//  Created by apple on 20/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class WeekCell: UICollectionViewCell {
    @IBOutlet weak var weekLbl : UILabel!
    @IBOutlet weak var lineView : UIView!
    
    func setColor(color:UIColor){
        weekLbl.textColor = color
        lineView.backgroundColor = color
    }
}
