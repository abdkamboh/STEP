//
//  ViewController.swift
//  STEP
//
//  Created by apple on 05/06/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class OrientationViewController: UIViewController {

   var data = [
    OrientationModel("text", "STEP is a strategic and tactical entry test preparatory programme by the Punjab Group. It offers entry test preparation services to students so that they can be admitted to professional institutes. Our online entry test preparation comprises of a question bank of 30,000+ MCQS, video lectures, evaluative test papers interlinked with great discussion videos that promote development of critical skills that harness higher order thinking abilities. We hope our students benefit from our portal and achieve their goals. Best of luck.", "STEP ONLINE TEST PREPARATION"),
    OrientationModel("video", "PZ-za43f9-w", ""),
    OrientationModel("text", "To ease the process kindly watch the tutorial to understand how you can benefit from our portal for a wholesome test preparation experience", "TUTORIAL STEP Students"),
     OrientationModel("video", "l3QWgW1MvFc", "")
    ]
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var wheelImage : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        wheelImage.startRotateBy(angle: -(Double.pi/2))

        // Do any additional setup after loading the view.
    }
    
   @IBAction func sideMenu(sender:UIButton){
        makeRightSideMenu(sender: sender)
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

}
extension OrientationViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let item = data[indexPath.row]
        if item.type == "text"{
          let  cell = tableView.dequeueReusableCell(withIdentifier: "TextCell") as! TextCell
            cell.heading.text = item.heading
            cell.discription.text = item.textLink
            return cell
        }else{
            let  cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
            cell.youTubeView.load(withVideoId: item.textLink)
            cell.height.constant = 250
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class OrientationModel {
    let type, textLink,heading: String

    enum CodingKeys: String, CodingKey {
        case type
        case textLink = "text/link"
        case heading
    }

    init(_ type: String, _ textLink: String,_ heading: String) {
        self.type = type
        self.heading = heading
        self.textLink = textLink
    }
}

