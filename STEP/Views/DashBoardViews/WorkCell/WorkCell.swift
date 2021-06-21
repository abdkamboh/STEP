//
//  WorkCell.swift
//  STEP
//
//  Created by apple on 20/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class WorkCell: UITableViewCell {
    @IBOutlet weak var lineView : UIView!
      @IBOutlet weak var title : UILabel!
      @IBOutlet weak var disImage : UIImageView!
      @IBOutlet weak var startView : UIView!
      @IBOutlet weak var startLabel : UILabel!
      @IBOutlet weak var disImageView : UIView!
      @IBOutlet weak var button : UIButton!
    @IBOutlet weak var topView : UIView!
    @IBOutlet weak var bottomView : UIView!
   var buttonAction : (() -> ())?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonTapped(_ sender: UIButton){
       // if the closure is defined (not nil)
       // then execute the code inside the subscribeButtonAction closure
       buttonAction?()
     }

}
