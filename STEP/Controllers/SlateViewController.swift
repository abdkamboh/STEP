//
//  SlateViewController.swift
//  STEP
//
//  Created by apple on 09/06/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SlateViewController: UIViewController {
let canvas = Canvas()
    @IBOutlet weak var upperView :UIView!
    @IBOutlet weak var navBar :UIView!
    @IBOutlet weak var clearBtn :UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        canvas.backgroundColor = .white

        // Do any additional setup after loading the view.
    }
  
    override func loadView() {
        self.view = canvas
        setViews()
    }
    @IBAction func clearBoard(_ sender:UIButton){
        canvas.clear()
    }
    @IBAction func backPressed(_ sender : UIButton){
         self.navigationController?.popViewController(animated: true)
     }
    override var preferredStatusBarStyle: UIStatusBarStyle {
           if #available(iOS 13.0, *) {
               return .darkContent
           } else {
               return .default
           }
       }
    /*
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setViews (){
        self.view.addSubview(upperView)
        self.view.addSubview(clearBtn)
        upperView.translatesAutoresizingMaskIntoConstraints = false
        clearBtn.translatesAutoresizingMaskIntoConstraints = false
        clearBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        clearBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        upperView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        upperView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        upperView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        navBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true

    }

}
