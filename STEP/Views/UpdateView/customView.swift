//
//  customView.swift
//  dynamicLinking
//
//  Created by Farhan Yousaf on 15/09/2020.
//  Copyright © 2020 Farhan Yousaf. All rights reserved.
//

import UIKit

class customView: UIView {
    @IBOutlet weak var popupView:UIView!
    @IBOutlet weak var updateButton:UIButton!
    @IBOutlet weak var message:UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        //Code For Load Nib File
        let _ = self.loadViewFromNib()
        
        //Code For Add Corner Radius.
        self.popupView.layer.cornerRadius = 10
        self.updateButton.layer.cornerRadius = 5
        //Code For Add shadow
        self.addShadow()
        
    }
    
    func loadViewFromNib()->UIView
    {
        let bundle = Bundle.init(for: type(of: self))
        let nib = UINib(nibName: "customView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        addSubview(view)
        return view
        
    }
    
    func addShadow()
    {
        self.popupView.layer.shadowColor = UIColor.black.cgColor
        self.popupView.layer.shadowOpacity = 0.5
        self.popupView.layer.shadowRadius = 5
        self.popupView.layer.shadowOffset = .zero
    }
    
    @IBAction func update_Pressed()
    {
        self.isHidden = true
        if let url = URL(string: "itms-apps://apple.com/app/id1259751445") {
            UIApplication.shared.open(url)
        }
    }
    
}
