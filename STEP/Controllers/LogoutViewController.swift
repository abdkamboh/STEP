//
//  tabViewController.swift
//  STEP
//
//  Created by apple on 12/06/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class LogoutViewController: UIViewController {
    var navigation = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
               return .lightContent
           
       }
    @IBAction func YesPress(){
        saveUserData(value: nil)
               self.dismiss(animated: true, completion: nil)
               self.removeFromParent()
       // if  #available(iOS 13.0, *){
        self.navigation.popToRootViewController(animated: true)
      //  }else{
       //     appDelegate.showHomeScreen()
      //  }
    }
    @IBAction func NoPress(){
        self.dismiss(animated: true, completion: nil)
        self.removeFromParent()

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
