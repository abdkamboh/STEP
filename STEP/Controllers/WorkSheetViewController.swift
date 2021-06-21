//
//  WorkSheetViewController.swift
//  STEP
//
//  Created by apple on 22/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class WorkSheetViewController: UIViewController {
    var workId = String()
    var type = String() // dataType
    var detailData : DetailListModel!
    var tableData : [WorkSheetModel]?

    override func awakeFromNib() {
        super.awakeFromNib()
  
    }
    @IBOutlet weak var imgView : UIImageView!
    
    @IBOutlet weak var wheelImage : UIImageView!
    @IBOutlet weak var dayName : UILabel!
    @IBOutlet weak var titleNavBar : UILabel!
    @IBOutlet weak var dateDay : UILabel!
    @IBOutlet weak var lineView : UIView!
    @IBOutlet weak var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
               self.titleNavBar.text = type
               callingApi(wid: workId)
               tableView.delegate = self
               tableView.dataSource = self
      //   wheelImage.startRotateBy(angle: -(Double.pi/2))
       
      
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
           if #available(iOS 13.0, *) {
               return .darkContent
           } else {
               return .default
           }
       }
     @IBAction func backPressed(_ sender : UIButton){
         self.navigationController?.popViewController(animated: true)
     }

    @IBAction func sideMenu(sender:UIButton){
         makeRightSideMenu(sender: sender)
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
extension WorkSheetViewController{
    
    func setLablValues(date :String){
        let day =  getDayName(date)
        let date1 = DateConvert(date)
        self.dayName.text =  day
        if let val = detailData.fullName{
            self.dateDay.text = "\(date1)-\(getDAyValue(day: val))"
        }else{
            self.dateDay.text = ""
        }
    }

    func callingApi(wid:String)  {
        //        if ReachabilityManager.isNetworkConnected()
        //        {
        if (self.isInternetConnected())
        {
            CustomLoader.instance.showLoaderView()
            
            let url = "\(HTTP.BaseUrl)Work/workone"
            print("URL: ",url)
            
            postManagerUser(method: "POST", isThisURLEmbdedData: false, urlString: url, parameter: ["workDayId":wid], success: {(value) in
                do
                {
                    let jsonObject = try JSONDecoder().decode([DetailListModel]?.self, from: value)
                    DispatchQueue.main.async {
                        if let value = jsonObject
                        {
                             if value.count > 0 {
                            self.detailData =  value[0]
                            DispatchQueue.main.async {
                                self.setLablValues(date: self.detailData.dated ?? "")
                                self.parseData()
                                
                                
                                //self.tableView.reloadData()
                            }
                        }
                        }
                    }
                    
                }
                catch
                {
                    DispatchQueue.main.async {
                        self.POPUp(message: "No data found", time: 1.8)
                    }
                }
                
            }, failure: {(err) in
                
                DispatchQueue.main.async {
                    self.POPUp(message: "Something went wrong", time: 1.8)
                }
            })
            //        }else{
            //           // self.Alert(message: Controller.internetConnectionMsg)
            //            self.POPUp(message: "No Internet Connection.", time: 1.8)
            //
        }
    }
    
    
    func parseData(){
        
        if let jsonObject =  detailData.workSheet?.data(using: .utf8)!{
            do {
                let data = try JSONDecoder().decode([WorkSheetModel].self, from: jsonObject)
                tableData = []
                for obj in data{
                    if obj.type == self.type{
                        self.tableData?.append(obj)
                    }
                }
                tableData = tableData?.sorted { $0.courseID! < $1.courseID! }
                tableView.reloadData()
            } catch {
                print(error)
            }
            
            
        }
    }
}



extension WorkSheetViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tableData?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkSheetCell") as! WorkSheetCell
        cell.title.text = item?.courseID ?? ""
        cell.subtitle.text = item?.title ?? ""
        cell.testButton.tag = indexPath.row
        if let image = UIImage(named: "\(item?.courseID ?? "")Work"){
            cell.disImage.image = image
        }else {
            
            cell.disImage.image = UIImage(named: "ic_menu_resource")
        }
        cell.testButton.addTarget(self, action: #selector(testButtonPressed(sender:)), for: .touchUpInside)
        return cell
    
    }
    
    @objc func testButtonPressed(sender: UIButton){
      let testid =  tableData?[sender.tag].id ?? ""
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let vc = storyboard.instantiateViewController(withIdentifier: "WorkSheetTestViewController") as! WorkSheetTestViewController
         vc.testId = testid
        vc.date = self.dateDay.text ?? ""
        vc.day = self.dayName.text ?? ""
     
         self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
