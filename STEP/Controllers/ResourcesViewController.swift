//
//  ResorcesViewController.swift
//  STEP
//
//  Created by apple on 09/06/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import DropDown
class ResourcesViewController: UIViewController, UITextFieldDelegate {
    
    var workSheetList = ResourceModel()
    var testList = ResourceModel()
    var dropDownData = [BindProgramModelElement]()
    var searchData: ResourceModel = []
    var search : String = ""
    var type = "WorkSheet"
    var programid = String()
    var batch = Int()
    
    @IBOutlet weak var arrow :  UIImageView!
    @IBOutlet weak var wheelImage : UIImageView!
    
    @IBOutlet weak var boldLbl :UILabel!
    @IBOutlet weak var lightLbl : UILabel!
    @IBOutlet weak var searchBtn:UIButton!
    @IBOutlet weak var sideMenuBtn:UIButton!
    @IBOutlet weak var navTitle:UILabel!
    @IBOutlet weak var searchView:UIView!
    @IBOutlet weak var searchTextField:UITextField!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var animateView : UIView!
    @IBOutlet weak var workSheetBtn : UIButton!
    @IBOutlet weak var testBtn : UIButton!
    @IBOutlet weak var noDataLabel :UILabel!
    @IBOutlet weak var drowpDownBtn : UIButton!
    let dropDown = DropDown()
    override func viewDidLoad() {
        super.viewDidLoad()
        wheelImage.startRotateBy(angle: -(Double.pi/2))
        
        tableView.delegate = self
        tableView.dataSource =  self
        searchTextField.delegate = self
        setupChooseDropDown()
        print(batch)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func choose(_ sender: AnyObject) {
        dropDown.show()
        rotateImage(image: arrow, angle: 180)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func searchPressed(_ sender:UIButton){
        
        searchTextField.becomeFirstResponder()
        setViews(bool: true)
    }
    @IBAction func searchClosePrssed(_ sender:UIButton){
        
        searchTextField.resignFirstResponder()
        setViews(bool: false)
        if type == "Test"{
            searchData = testList
        }else{
            searchData = workSheetList
        }
        self.sortData()
        tableView.reloadData()
    }
    @IBAction func backPressed(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setViews(bool:Bool){
        searchTextField.text = ""
        searchView.isHidden = !bool
        navTitle.isHidden = bool
        sideMenuBtn.isHidden = bool
        searchBtn.isHidden = bool
    }
    @IBAction func sideMenu(sender:UIButton){
        makeRightSideMenu(sender: sender)
    }
    @IBAction func workSheetBtnPress(_ sender : UIButton){
        type = sender.titleLabel?.text ?? ""
        if workSheetList.count ==  0{
            callingApi(pid: programid, batch: self.batch, type: type)
            
        }
        DispatchQueue.main.async {
            if self.workSheetList.count == 0{
                self.noDataLabel.isHidden = false
                self.noDataLabel.text = "No Worksheet Uploaded"
            }else{
                self.noDataLabel.isHidden = true
                self.noDataLabel.text = ""
                
            }
            self.searchData = self.workSheetList
            self.sortData()
            self.testBtn.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9254901961, blue: 0.9450980392, alpha: 1)
            self.animateView(btn: sender)
        }
    }
    @IBAction func testBtnPress(_ sender : UIButton){
        type = sender.titleLabel?.text ?? ""
        if testList.count ==  0{
            callingApi(pid: programid, batch: self.batch, type: type)
            
        }
        DispatchQueue.main.async {
            if self.testList.count == 0{
                self.noDataLabel.isHidden = false
                self.noDataLabel.text = "No Test Uploaded"
            }else{
                self.noDataLabel.isHidden = true
                self.noDataLabel.text = ""
                
            }
            self.searchData = self.testList
            self.sortData()
            self.workSheetBtn.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9254901961, blue: 0.9450980392, alpha: 1)
            self.animateView(btn: sender)
        }
        
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    func animateView(btn:UIButton){
        btn.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9607843137, blue: 0.9725490196, alpha: 1)
        self.tableView.reloadData()
        let xPosition = btn.frame.minX
        let yPosition =  btn.frame.minY - 2
        let width =  btn.frame.size.width
        UIView.animate(withDuration: 0.4, animations: {
            self.animateView.frame = CGRect(x: xPosition, y: yPosition, width: width, height: 2)
        })
    }
    func setupChooseDropDown() {
        DispatchQueue.main.async {
            
            
            self.dropDown.anchorView =  self.drowpDownBtn
            // By default, the dropdown will have its origin on the top left corner of its anchor view
            // So it will come over the anchor view and hide it completely
            // If you want to have the dropdown underneath your anchor view, you can do this:
            self.dropDown.bottomOffset = CGPoint(x: 0, y:  self.drowpDownBtn.bounds.height+5)
            self.dropDown.backgroundColor = .white
            self.dropDown.selectedTextColor = #colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.5019607843, alpha: 1)
            self.dropDown.selectionBackgroundColor = .clear
            self.dropDown.textColor = #colorLiteral(red: 0.5607843137, green: 0.5921568627, blue: 0.6392156863, alpha: 1)
            // You can also use localizationKeysDataSource instead. Check the docs.
            //        dropDownData = [
            //            DropDownModel(0, "8aa08620-cab9-44f4-b884-d24f0951ef62", "ECAT/LECAT", "(FSc)"),
            //            DropDownModel(1, "8aa08620-cab9-44f4-b886-d24f0951ef65", "ECAT/LECAT", "(ICs)")
            //        ]
            
            if self.dropDownData.count > 0{
                let value =  self.dropDownData[0]
                self.programid = self.dropDownData[0].studentProgramID ?? ""
                self.boldLbl.text = value.fullName ?? ""
                //  self.dropDownIndex = 0
                
                self.callingApi(pid: self.programid, batch: self.batch, type: self.type)
                
                
                
                
                var values = [String]()
                
                for item in  self.dropDownData{
                    values.append("\(item.fullName ?? "")")
                }
                
                self.dropDown.dataSource = values
                if values.count > 0{
                self.dropDown.selectRows(at: [0])
                // Action triggered on selection
                
                self.dropDown.selectionAction = { [] (index, item) in
                    self.rotateImage(image: self.arrow, angle: -360)
                    let value =  self.dropDownData[index]
                    self.boldLbl.text = value.fullName ?? ""
                    
                    self.programid = value.providedProgram ?? ""
                    self.type = self.workSheetBtn.titleLabel?.text ?? ""
                    self.workSheetBtnPress(self.workSheetBtn)
                    self.searchData = []
                    self.workSheetList = []
                    self.testList = []
                    self.tableView.reloadData()
                    
                    self.callingApi(pid: self.programid, batch: self.batch, type: self.type)
                    
                    
                }
                self.dropDown.cancelAction = {
                    self.rotateImage(image: self.arrow, angle: -360)
                }
                }
            }else{
                self.POPUp(message: "No DataFound", time: 1.8)
            }
        }
    }
}
extension ResourcesViewController{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if string.isEmpty
        {
            search = String(search.dropLast())
        }
        else
        {
            search=textField.text!+string
        }
        
        print(search)
        var arr = ResourceModel()
        if type == "Test"{
            arr = testList.filter{(x) -> Bool in
                (x.courseID?.lowercased().contains(search.lowercased()))!
            }}else{
            arr = workSheetList.filter{(x) -> Bool in
                (x.courseID?.lowercased().contains(search.lowercased()))!
            }
        }
        
        if arr.count > 0
        {
            searchData.removeAll(keepingCapacity: true)
            searchData = arr
            self.sortData()
        }
        else
        {
            searchData=[]
        }
        if search == ""{
            if type == "Test"{
                searchData = testList
            }
            else{
                searchData = workSheetList
            }
            self.sortData()
        }
        tableView.reloadData()
        return true
    }
    
    func callingApi(pid:String, batch:Int, type :String)  {
        //        if ReachabilityManager.isNetworkConnected()
        //        {
        if (self.isInternetConnected())
        {
            CustomLoader.instance.showLoaderView()
            
            let url = "\(HTTP.BaseUrl)Work/GetResourcesX"
            print("URL: ",url)
            
            postManagerUser(method: "POST", isThisURLEmbdedData: false, urlString: url, parameter: ["ProgramId":pid,"Batch":batch,"ActivityType":type], success: {(value) in
                do
                {
                    let jsonObject = try JSONDecoder().decode(ResourceModel?.self, from: value)
                    DispatchQueue.main.async {
                        if let value = jsonObject
                        {
                            DispatchQueue.main.async {
                                
                                if type == "Test"{
                                    self.testList = value
                                    
                                    if self.testList.count == 0{
                                        self.noDataLabel.isHidden = false
                                        self.noDataLabel.text = "No Test Uploaded"
                                    }else{
                                        for i in 0...(self.testList.count-1){
                                            self.testList[i].fullName = self.testList[i].fullName?.lowercased()
                                            self.testList[i].fullName = self.testList[i].fullName?.capitalizedFirstLetter
                                        }
                                        self.searchData = self.testList
                                        self.noDataLabel.isHidden = true
                                        self.noDataLabel.text = ""
                                        
                                    }
                                }else{
                                    
                                    self.workSheetList = value
                                    
                                    if self.workSheetList.count == 0{
                                        self.noDataLabel.isHidden = false
                                        self.noDataLabel.text = "No Worksheet Uploaded"
                                    }else{
                                        for i in 0...(self.workSheetList.count-1){
                                            self.workSheetList[i].fullName = self.workSheetList[i].fullName?.lowercased()
                                            self.workSheetList[i].fullName = self.workSheetList[i].fullName?.capitalizedFirstLetter
                                        }
                                        self.searchData = self.workSheetList
                                        
                                        self.noDataLabel.isHidden = true
                                        self.noDataLabel.text = ""
                                        
                                    }
                                }
                                
                                self.sortData()
                                self.tableView.reloadData()
                                
                                
                                //self.tableView.reloadData()
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
    func sortData(){
           self.searchData = self.searchData.sorted {(a1,b1)-> Bool in
               return a1.fullName!.localizedStandardCompare(b1.fullName!) == ComparisonResult.orderedAscending
           }
           self.searchData = self.searchData.sorted { $0.courseID! < $1.courseID! }
    }
}
extension ResourcesViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceMainCell") ?? UITableViewCell()
            return cell
        }else
            
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceCell") as! ResourceCell
            
            cell.title.text = searchData[indexPath.row-1].fullName ?? ""
            cell.subject.text = searchData[indexPath.row-1].courseID ??  ""
            
            let strurl = searchData[indexPath.row-1].linked?.replacingOccurrences(of: " ", with: "%20")
            if let url = URL(string: strurl ?? ""){
                cell.link = url
            }else{
                POPUp(message: "Url Error.", time: 1.8)
            }
            if indexPath.row == (tableView.numberOfRows(inSection: indexPath.section) - 1){
                cell.lineView.isHidden = true
            }else{
                cell.lineView.isHidden = false
                
            }
            return cell
            
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchTextField.resignFirstResponder()
    }
    
}
extension String {
    var capitalizedFirstLetter:String {
        let string = self
        return string.replacingCharacters(in: startIndex...startIndex, with: String(self[startIndex]).capitalized)
    }
}

