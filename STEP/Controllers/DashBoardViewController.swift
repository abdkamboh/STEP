//
//  DashBoardViewController.swift
//  STEP
//
//  Created by apple on 19/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import DropDown
import MSAL
import SafariServices
//import youtube_ios_player_helper

class sideMenuModel: Codable {
    let imageName, title: String
    
    init(imageName: String, title: String) {
        self.imageName = imageName
        self.title = title
    }
}

class DashBoardViewController: UIViewController,SFSafariViewControllerDelegate {
    let dir = NSSearchPathForDirectoriesInDomains(
        .documentDirectory,
        .userDomainMask, true)
    
    var dic:UIDocumentInteractionController?
    var files:NSMutableArray = NSMutableArray()
    let Resources = "Resources"
    let Vocabulary = "Vocabulary"
    let Oreintation = "Orientation"
    let JoinLiveTeams = "Join Live Teams"
    var programId = String()
//    var dropDownData = [DropDownModel]()
    var dropDownIndex = -1
    var menuData = [sideMenuModel]()
    
    var weekArray : [WeekClass]?
    var ProgramModleArray:[ProgramModleElement]?
    var tableData : [ProgramModleElement]?
    var totalWeeksCount = 0
    var totalDaysCounter = 0
    var lastWeekHandler = false
    var weekHandler = 0
    var selectedWeek = 0
    var sosLink = ""
    var data:[[ProgramModleElement]]?
    fileprivate var ProgramModel = [BindProgramModelElement]()
    
    @IBOutlet weak var sideTableView : UITableView!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var topSideView: UIView!
    @IBOutlet weak var bottomSideView: UIView!
    @IBOutlet weak var tabView: UIView!
    
    @IBOutlet var leadingCon: NSLayoutConstraint!
    @IBOutlet weak var boldLbl :UILabel!
    @IBOutlet weak var lightLbl : UILabel!
    @IBOutlet weak var arrow :  UIImageView!
    @IBOutlet weak var dropdowpView : UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var drowpDownBtn : UIButton!
    @IBOutlet weak var wheelImage : UIImageView!
    
    let dropDown = DropDown()
    var batch = -1
    var vrification = String()
    var user : LoginModel!
    override func viewDidLoad() {
        user = getUserData()
        self.getBindPrograms(userId: self.user.varification ?? "")
        vrification = user.varification ?? ""
        //vrification = "-1"
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tabView.addGestureRecognizer(tap)
        if vrification == "-1"{
            self.batch = 1

        }else{
        self.batch = user.batch ?? 1
        }
       // dropDownData = getDropDownData(vrf: vrification,batch: self.batch)
        
        super.viewDidLoad()
        getMenu(verification: vrification)
        hideNavigationBar()
        wheelImage.startRotateBy(angle: -(Double.pi/2))
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        sideTableView.delegate = self
        sideTableView.dataSource = self
        self.sideView.isHidden = true
        topSideView.isHidden = true
        bottomSideView.isHidden = true
        tabView.isHidden = true
        tabView.alpha = 0
        
        
        
        
        //callingApi()
        // The view to which the drop down will appear on
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        hideMune()
    }
    
    func getBindPrograms(userId:String)
    {
        print("User Id : ",userId)
        
        if (self.isInternetConnected())
        {
            CustomLoader.instance.showLoaderView()
            
            let url = "\(HTTP.BaseUrl)Work/GetBindProgram"
            print("URL: ",url)
            
            postManagerUser(method: "POST", isThisURLEmbdedData: false, urlString: url, parameter: ["Username":userId], success: {(value) in
                do
                {
                    let jsonObject = try JSONDecoder().decode(BindProgramModel.self, from: value)
                    DispatchQueue.main.async {
                        if let value = jsonObject
                        {
                            if value.count > 0{
                            DispatchQueue.main.async {
                                self.ProgramModel = value
                                self.setupChooseDropDown()
                                self.getSosLink(programeId: value[0].studentProgramID ?? "", Batch: self.batch)
                                self.getDialog(programeId: value[0].studentProgramID ?? "", Batch: self.batch)

                            }
                        }else{
                                self.POPUp(message: "No Data Found", time: 1.8)
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
        }
    }
    
    func getDialog(programeId:String, Batch:Int)
    {
        if (self.isInternetConnected())
        {
            CustomLoader.instance.showLoaderView()
            
            let url = "\(HTTP.BaseUrl)Work/GetDialog"
            postManagerUser(method: "POST", isThisURLEmbdedData: false, urlString: url, parameter: ["ProgramId":programeId, "Batch":Batch], success: {(value) in
                do
                {
                    let jsonObject = try JSONDecoder().decode(GetDialogModel.self, from: value)
                    DispatchQueue.main.async {
                        if let value = jsonObject
                        {
                            if value.count > 0{
                            DispatchQueue.main.async {
                                self.alert(message: value[0].getDialogModelDescription ?? "", title: value[0].header ?? "")
                            }
                        }else{
                              //  self.POPUp(message: "No Data Found", time: 1.8)
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
        }
    }
    
    func alert(message:String, title:String)
    {
                let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
    }
    
    
    func getSosLink(programeId:String, Batch:Int)
    {
        if (self.isInternetConnected())
        {
            CustomLoader.instance.showLoaderView()
            
            let url = "\(HTTP.BaseUrl)Work/GetSos"
            print("URL: ",url)
            
            postManagerUser(method: "POST", isThisURLEmbdedData: false, urlString: url, parameter: ["ProgramId":programeId, "Batch":Batch], success: {(value) in
                do
                {
                    let jsonObject = try JSONDecoder().decode(GetSosModel.self, from: value)
                    DispatchQueue.main.async {
                        if let value = jsonObject
                        {
                            if value.count > 0{
                            DispatchQueue.main.async {
                                self.sosLink = value[0].link ?? ""
                            }
                        }else{
                                self.POPUp(message: "No Data Found", time: 1.8)
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
        }
    }
    @IBAction func schemeofStudy(sender:UIButton){
        if self.isInternetConnected()
        {
            CustomLoader.instance.showLoaderView()
            
//            var urlString = getSchemeLink(vrf: vrification, batch: batch)
           let urlString = self.sosLink.replacingOccurrences(of: " ", with: "%20")
            
            if (self.isInternetConnected()){
                if let url = URL(string: urlString) {
                    // Add files
                    self.files.add(url.lastPathComponent)
                    
                    // Download
                    let config = URLSessionConfiguration.default
                    let session = Foundation.URLSession(configuration: config,
                                                        delegate: self ,
                                                        delegateQueue: OperationQueue.main)
                    let task = session.downloadTask(with: url)
                    task.resume()
                } else {
                    // Alert
                    DispatchQueue.main.async {
                        CustomLoader.instance.hideLoaderView()
                    }
                    let alert = UIAlertController(title: "Error", message: "url is invalid.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    @IBAction func humBurgerMenu(sender:UIButton){
        showMune()
    }
    @IBAction func crossMenu(sender:UIButton){
        hideMune()
    }
    func hideMune(){
        leadingCon.constant = -150
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.tabView.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.06666666667, blue: 0.06666666667, alpha: 1).withAlphaComponent(0.5)
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
            self.tabView.alpha = 0
            self.sideView.isHidden = true
            self.topSideView.isHidden = true
            self.bottomSideView.isHidden = true
            
        }
    }
    func showMune(){
        self.sideView.isHidden = false
        self.topSideView.isHidden = false
        self.bottomSideView.isHidden = false
        self.tabView.isHidden = false
        leadingCon.constant = 0
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.tabView.alpha = 1
            
            self.tabView.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.06666666667, blue: 0.06666666667, alpha: 1).withAlphaComponent(0.5)
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
            
            
        }
    }
    
    @IBAction func sideMenu(sender:UIButton){
        makeRightSideMenu(sender: sender)
    }
    func getBoldString(fname:String,lname:String)->String{
        let boldAttribute = [
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 15.0)!
        ]
        let regularAttribute = [
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 15.0)!
        ]
        let boldText = NSAttributedString(string: fname, attributes: boldAttribute)
        let regularText = NSAttributedString(string: " \(lname)", attributes: regularAttribute)
        let newString = NSMutableAttributedString()
        newString.append(boldText)
        newString.append(regularText)
        return "\(newString)"
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
            
            if self.ProgramModel.count > 0{
                
                self.boldLbl.text = self.ProgramModel[0].fullName
                headType = self.ProgramModel[0].fullName ?? ""
                self.dropDownIndex = 0
                self.programId = self.ProgramModel[0].studentProgramID ?? ""
                self.callingApi(pid:  self.ProgramModel[0].studentProgramID ?? "", batch: self.batch)
                
                var values = [String]()
                for item in  self.ProgramModel{
                    values.append("\(item.fullName ?? "")")
                }
                
                self.dropDown.dataSource = values
                if values.count > 0{
                    self.dropDown.selectRows(at: [0])
                }
                // Action triggered on selection
                self.dropDown.selectionAction = { [] (index, item) in
                    self.rotateImage(image: self.arrow, angle: -360)
                    let value =  self.ProgramModel[index]
                    self.boldLbl.text = value.fullName ?? ""
                    self.selectedWeek = 0
                    self.dropDownIndex = index
                    headType = value.fullName ?? ""
                    self.programId = value.studentProgramID ?? ""

                    self.callingApi(pid: value.studentProgramID ?? "", batch: self.batch)
                    self.getSosLink(programeId: value.studentProgramID ?? "", Batch: self.batch)
                    
                    
                }
                self.dropDown.cancelAction = {
                    self.rotateImage(image: self.arrow, angle: -360)
                }
                
            }else{
                self.POPUp(message: "No DataFound", time: 1.8)
            }
        }
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
    
    func callingApi(pid:String, batch : Int)  {
        //        if ReachabilityManager.isNetworkConnected()
        if (self.isInternetConnected())
        {
            CustomLoader.instance.showLoaderView()
            
            let url = "\(HTTP.BaseUrl)Work/WorkBatch"
            print("URL: ",url)
            
            postManagerUser(method: "POST", isThisURLEmbdedData: false, urlString: url, parameter: ["ProgramId":pid,"Batch": batch], success: {(value) in
                do
                {
                    let jsonObject = try JSONDecoder().decode([ProgramModleElement]?.self, from: value)
                    DispatchQueue.main.async {
                        if let value = jsonObject
                        {
                            if value.count > 0{
                            self.ProgramModleArray = value
                            self.getweeks()
                            self.getdata()
                            DispatchQueue.main.async {
                                if let data = self.data{
                                    if data.count > 0{
                                        self.tableData = data[0]
                                    }else{
                                        self.tableData = []
                                    }
                                }
                                self.scrolltoActiveDay()
                            }
                        }else{
                                self.POPUp(message: "No Data Found", time: 1.8)
                           self.tableData = []
                            self.data = []
                            self.tableView.reloadData()
                            self.collectionView.reloadData()
                            
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
}
//let numbers = Array(1...100)
//let result = numbers.chunked(into: 5)

extension DashBoardViewController {
    
    func getWeekNumber(date:Date)-> WeekClass{
        let calendar = Calendar.current
        let weekNumber = calendar.component(.weekOfYear, from: date)
        let year = calendar.component(.year, from: date)
        
        return WeekClass(weekNumber, year)
        
    }
    func getweeks(){
        var weeks = [WeekClass]()
        
        if let value = ProgramModleArray{
            for data in value{
                
                if let date = getDateFromString(dateString: data.dated ?? ""){
                    let week = getWeekNumber(date: date)
                    if !weeks.contains(where: {$0.week == week.week && $0.year == week.year}){
                        weeks.append(week)
                    }
                }
                
            }
        }
        weeks = weeks.sorted { $0.week < $1.week }
        weekArray = weeks
        
    }
    
    func getdata(){
        if let value = ProgramModleArray{
            data = []
            if let weekss = weekArray{
                
                for week in weekss{
                    var array = [ProgramModleElement]()
                    for val in value{
                        if let date = getDateFromString(dateString: val.dated ?? ""){
                            let week1 = getWeekNumber(date: date)
                            if week.week == week1.week && week.year == week1.year{
                                array.append(val)
                            }
                        }
                    }
                    data?.append(array)
                }
            }
            //  collectionView.reloadData()
            print("done")
        }
    }
    
    func scrolltoActiveDay(){
        if let value = data{
            if value.count > 0{
                let val = value[0]
                if val.count > 0{
                    
                    
                    let strdate = value[0][0].dated
                    var week = 0
                    var day = 0
                    if   var lastDate = getDateFromString(dateString: strdate ?? ""){
                        
                        
                        for i in 0...(value.count-1){
                            for j in 0...(value[i].count-1){
                                let val = value[i][j]
                                if let date = getDateFromString(dateString: val.dated ?? ""){
                                    if val.isEnable == 1 && date > lastDate{
                                        week = i
                                        day = j
                                        lastDate = date
                                    }
                                }
                            }
                            print(i)
                            print(value.count)
                        }
                        selectedWeek = week
                        tableData = value[week]
                        tableView.reloadData()
                        collectionView.reloadData()
                        collectionView.scrollToItem(at: IndexPath(item: selectedWeek, section: 0), at: .centeredHorizontally, animated: false)
                        tableView.scrollToRow(at: IndexPath(row: 0, section: day), at: .top, animated: false)
                        
                        
                    }
                    
                }
            }else{
                tableData = []
                data = []
                tableView.reloadData()
                collectionView.reloadData()
            }
        }else{
            tableData = []
            data = []
            tableView.reloadData()
            collectionView.reloadData()
        }
    }
    
}
extension DashBoardViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCell", for: indexPath) as! WeekCell
        cell.weekLbl.text = "Week \(indexPath.item+1)"
        
        if selectedWeek == indexPath.item{
            cell.setColor(color: #colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.5019607843, alpha: 1))
        }else{
            cell.setColor(color: #colorLiteral(red: 0.6196078431, green: 0.631372549, blue: 0.6666666667, alpha: 1))
            cell.lineView.backgroundColor = .white
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedWeek = indexPath.item
        tableData = data?[indexPath.item]
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var noOfCellsInRow = 0
        if let count =  data?.count{
            if count > 5{
                noOfCellsInRow = 5
            }else{
                noOfCellsInRow = count
            }
        }
        
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: size, height: Int(collectionView.frame.size.height))
    }
    //  func Rate(){
    //    self.optionView.isHidden = true
    //    if let url = URL(string: "https://itunes.apple.com/us/app/step-by-pgc/id1259751445?ls=1&mt=8") {
    //      if #available(iOS 10.0, *) {
    //        UIApplication.shared.open(url, options: [:])
    //      } else {
    //        UIApplication.shared.openURL(url)
    //      }
    //    }
    //  }
    //    @IBAction func ShareAction(_ sender: Any) {
    //      let shareText = "STEP by PGC"
    //
    //      let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
    //      if let popoverPresentationController = vc.popoverPresentationController {
    //        vc.popoverPresentationController? .sourceView = self.view
    //        vc.popoverPresentationController? .sourceRect = CGRect(x:self.shareOutlet.bounds.midX, y: self.shareOutlet.bounds.midY,width: 315,height: 230)
    //        //CGRect.init(x:0,y:0,width:self.view.bounds.width,height: 100)
    //        present(vc, animated: true)
    //      }else{
    //        present(vc, animated: true)
    //      }
    //
    //    }
    
    
    func getMenu (verification: String){
        menuData = []
        let vrf = getType(vrf: verification)
        switch vrf {
        case MDCATLMDCAT,ETEAMEDICAL,ETEAFUNGAT,ETEAENGINEERING:
            
            menuData  = [sideMenuModel(imageName: "ic_menu_resource", title: "Resources"),sideMenuModel(imageName: "ic_menu_vocabulary", title: "Vocabulary"),sideMenuModel(imageName: "ic_menu_team", title: "Join Live Teams")]
            break
        case ECATLECAT,FUNGAT:
            
            menuData  = [sideMenuModel(imageName: "ic_menu_resource", title: "Resources"),sideMenuModel(imageName: "ic_menu_orientation", title: "Orientation"),sideMenuModel(imageName: "ic_menu_team", title: "Join Live Teams")]
            break
        case FULLACCESS:
            
            menuData  = [sideMenuModel(imageName: "ic_menu_resource", title: "Resources"),
                         sideMenuModel(imageName: "ic_menu_vocabulary", title: "Vocabulary"),
                         sideMenuModel(imageName: "ic_menu_orientation", title: "Orientation"),
                         sideMenuModel(imageName: "ic_menu_team", title: "Join Live Teams"),
                         sideMenuModel(imageName: "Batch", title: "1"),
                         sideMenuModel(imageName: "Batch", title: "2"),
                         sideMenuModel(imageName: "Batch", title: "3"),
                         sideMenuModel(imageName: "Batch", title: "4"),
                         sideMenuModel(imageName: "Batch", title: "5")]
            break
        default:
            menuData = [sideMenuModel(imageName: "ic_menu_resource", title: "Resources"),sideMenuModel(imageName: "ic_menu_team", title: "Join Live Teams")]
        }
        
        sideTableView.reloadData()
    }
}

extension DashBoardViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == self.tableView{
            return 25
        }
        
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.sideTableView{
            return 1
        }
        else{
            return tableData?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.sideTableView{
            return menuData.count
        }
        else{
            if let data = tableData?[section]{
                
                return data.getInnerValuesCount() + 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.sideTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
            if menuData[indexPath.row].imageName == "Batch"{
                cell.MenuTitle.text = "Batch \(menuData[indexPath.row].title)"
                cell.menuImage.isHidden =  true

            }else{
                cell.MenuTitle.text = menuData[indexPath.row].title
                cell.menuImage.image = UIImage(named:(menuData[indexPath.row].imageName))
                cell.menuImage.isHidden =  false

            }
            return cell
        }
        else{
            
            if let data = tableData?[indexPath.section]{
                if indexPath.row == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell") as! MainCell
                    let date = DateConvert(data.dated ?? "")
                    let day = getDayName(data.dated ?? "")
                    cell.setValues(date: date, day: day, dayNo: data.fullName ?? "")
                    if data.isEnable == 1{
                        cell.line.backgroundColor = #colorLiteral(red: 0.5725490196, green: 0.8862745098, blue: 0.6235294118, alpha: 1)
                        cell.setColor(color: #colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.5019607843, alpha: 1))
                    }else{
                        cell.line.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.2784313725, blue: 0.3803921569, alpha: 1)
                        cell.setColor(color: #colorLiteral(red: 0.5607843137, green: 0.5921568627, blue: 0.6392156863, alpha: 1))
                    }
                    return cell
                }else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "WorkCell") as! WorkCell
                    let values = data.getInnerValues()
                    let str = values[indexPath.row-1]
                    cell.disImageView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 1, alpha: 1)
                    if data.isEnable == 1{
                        cell.title.text = str
                        cell.disImage.image = UIImage(named: getEnableImage(title: str))
                        cell.button.tag = getTag(title: str)
                        cell.startView.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.8980392157, blue: 1, alpha: 1)
                        // cell.button.addTarget(self, action: #selector(StartButton(sender:)), for: .touchUpInside)
                        //                    cell.button.actionHandler(controlEvents: .touchUpInside, ForAction: {()in
                        //
                        //                        self.StartButton(section: indexPath.section, tag: cell.button.tag)
                        //                    })
                        
                        cell.buttonAction = { [unowned self] in
                            self.StartButton(section: indexPath.section, tag: self.getTag(title: str))
                        }
                        cell.title.textColor = #colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.5019607843, alpha: 1)
                        cell.startLabel.textColor = #colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.5019607843, alpha: 1)
                    }else{
                        cell.title.text = str
                        cell.disImage.image = UIImage(named: getDisableImage(title: str))
                        cell.button.tag = 0
                        cell.startView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 1, alpha: 1)
                        
                        cell.title.textColor = #colorLiteral(red: 0.5607843137, green: 0.5921568627, blue: 0.6392156863, alpha: 1)
                        cell.startLabel.textColor = #colorLiteral(red: 0.5607843137, green: 0.5921568627, blue: 0.6392156863, alpha: 1)
                        if vrification == "-1"{
                            cell.buttonAction = { [unowned self] in
                                self.StartButton(section: indexPath.section, tag: self.getTag(title: str))
                            }
                        }else{
                            cell.buttonAction = { [unowned self] in
                                //    self.StartButton(section: indexPath.section, tag: self.getTag(title: str))
                            }
                        }
                        
                    }
                    if indexPath.row == 1{
                        cell.bottomView.isHidden = false
                        cell.topView.isHidden = true
                        cell.lineView.isHidden = false
                        
                    }else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1{
                        cell.bottomView.isHidden = true
                        cell.topView.isHidden = false
                        cell.lineView.isHidden = true
                    }else{
                        cell.bottomView.isHidden = false
                        cell.topView.isHidden = false
                        cell.lineView.isHidden = false
                    }
                    return cell
                }
                
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == sideTableView{
            let title = menuData[indexPath.row].title
            switch title {
            case Resources:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ResourcesViewController") as! ResourcesViewController
                vc.dropDownData = self.ProgramModel
                //vc.programid = dropDownData[dropDownIndex].ProgramId
                vc.batch = self.batch
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case Vocabulary:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "VocabularyViewController") as! VocabularyViewController
                vc.programId = self.ProgramModel[dropDownIndex].studentProgramID ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case Oreintation:
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "OrientationViewController") as! OrientationViewController
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case JoinLiveTeams:
                if let url = URL(string: "msteams://teams.microsoft.com/") {
                    UIApplication.shared.open(url)
                }
                break
            default:
                self.batch = Int(title) ?? 1
                self.callingApi(pid:  programId, batch: self.batch)
                hideMune()

            }
        }
    }
    func StartButton(section: Int, tag : Int){
        
        if tag > 2{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier:"DetailsListViewController") as! DetailsListViewController
            //                storyboard.instantiateViewController(withIdentifier: "DetailsListViewController") as DetailsListViewController
            vc.workId = tableData?[section].workDayID ?? ""
            vc.type = getTagValue(title: tag)
            self.navigationController?.pushViewController(vc, animated: true)
        }else if tag == 2{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WorkSheetViewController") as! WorkSheetViewController
            vc.workId = tableData?[section].workDayID ?? ""
            vc.type = getTagValue(title: tag)
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
            vc.workId = tableData?[section].workDayID ?? ""
            vc.type = getTagValue(title: tag)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    func getEnableImage(title : String)->String{
        if title == "Test"{
            return ImageName.test
        }else if title == "WorkSheet"{
            return ImageName.workSheet
        }else if title == "Discussion"{
            return ImageName.discussion
        }else if title == "Lecture"{
            return ImageName.lecture
        }
        return ImageName.lecture
    }
    func getTag(title : String)->Int{
        if title == "Test"{
            return 1
        }else if title == "WorkSheet"{
            return 2
        }else if title == "Discussion"{
            return 3
        }else if title == "Lecture"{
            return 4
        }
        return 5
    }
    
    func getTagValue(title : Int)->String{
        if title == 1{
            return "Test"
        }else if title == 2{
            return "WorkSheet"
        }else if title == 3{
            return "Discussion"
        }else if title == 4{
            return "Lecture"
        }
        return "Orientation"
    }
    
    func getDisableImage(title : String)->String{
        if title == "Test"{
            return ImageName.untest
        }else if title == "WorkSheet"{
            return ImageName.unworkSheet
        }else if title == "Discussion"{
            return ImageName.undiscussion
        }else{
            return ImageName.unlecture
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


extension DashBoardViewController:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
        let data = try! Data(contentsOf: location)
        if data.count > 0 {
            let path =
                URL(fileURLWithPath: self.dir[0]).appendingPathComponent(self.files[self.files.count-1] as! String).path
            try? data.write(to: URL(fileURLWithPath: path), options: [.atomic])
            print(path)
            
            if let path = URL(fileURLWithPath: self.dir[0]).appendingPathComponent(self.files[0] as! String).path  as String?{
                print(path)
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFViewController") as! PDFViewController
                vc.path = path
                
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true, completion: nil)
                
            }
        }
    }
    
}
