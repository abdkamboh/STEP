//
//  TestViewController.swift
//  STEP
//
//  Created by apple on 26/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import WebKit
class AnswerSelected{
    var isCheck : Bool!
    var qno : Int!
    var selectedOption : String!
    var correctOption : String!
    var lastSaved:String!
    var lastReviewed:String!
    var isSaved:Bool!
    var isReviewed:Bool!
    var subject:Int!
    init(ischeck: Bool, qno:Int, sOption:String, cOption:String) {
        isCheck = ischeck
        self.qno = qno
        selectedOption = sOption
        correctOption = cOption
    }
    init(ischeck: Bool, qno:Int, sOption:String, cOption:String,save:Bool,review:Bool) {
        isCheck = ischeck
        self.qno = qno
        selectedOption = sOption
        correctOption = cOption
        isSaved = save
        isReviewed = save
    }
    init() {
        
    }
}
class TestViewController: UIViewController {
    var workId = String()
    var type = String()
    var remainingSeconds:Int!
    var selecteled = 0
    var selecteledSubject = 0
    var totalConter = 1
    var testData : [WorkSheetElementModel]?
    var mcqsList = [[Mcq]]()
    var mcqsData = [Mcq]()
    var detailData : DetailListModel!
    var SubjectData : [WorkSheetModel]?// dataType
    var AnswerArray = [[AnswerSelected]]()
    var reviewList = [AnswerSelected]()
    @IBOutlet weak var reload : UIImageView!
    @IBOutlet weak var timeLabel : UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var wheelImage : UIImageView!
    @IBOutlet weak var dayName : UILabel!
    @IBOutlet weak var titleNavBar : UILabel!
    @IBOutlet weak var dateDay : UILabel!
    @IBOutlet weak var lineView : UIView!
    @IBOutlet weak var webView : WKWebView!
    @IBOutlet weak var nextButton : UIButton!
    @IBOutlet weak var previousButton : UIButton!
    @IBOutlet weak var moreButton : UIButton!
    @IBOutlet weak var subjectName : UILabel!
    // current Question number
    @IBOutlet weak var counter : UILabel!
    // Attempted MCQs
    @IBOutlet weak var attemptedcounter : UILabel!
    @IBOutlet weak var activitControler : UIActivityIndicatorView!
    @IBOutlet weak var stackView : UIStackView!
    
    @IBOutlet weak var radioButtoA : RadioButtonView!
    @IBOutlet weak var radioButtoB : RadioButtonView!
    @IBOutlet weak var radioButtoC : RadioButtonView!
    @IBOutlet weak var radioButtoD : RadioButtonView!
    
    @IBOutlet weak var nextSubjecttButton : UIButton!
    @IBOutlet weak var previousSubjectButton : UIButton!
    @IBOutlet weak var saveButton : UIButton!
    @IBOutlet weak var reviewButton : UIButton!
    
    @IBOutlet weak var reviewListTableView:UITableView!
    @IBOutlet weak var reviewListView:UIView!
    @IBOutlet weak var acknowledgeView:UIView!

    var totalSecond = Int()
    var timer : Timer?
    var radioArray = [RadioButtonView]()
    var isAnswerSelect = false
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        radioArray = [radioButtoA,radioButtoB,radioButtoC,radioButtoD]
        hideNavigationBar()
        self.titleNavBar.text = type
        callingApi(wid: workId)
        collectionView.delegate = self
        collectionView.dataSource = self
        webView.navigationDelegate = self
        activitControler.isHidden = true
        reviewListView.isHidden = true
        acknowledgeView.isHidden = true
        wheelImage.startRotateBy(angle: -(Double.pi/2))
        
        self.reviewListTableView.dataSource = self
        self.reviewListTableView.delegate = self
        
    }
    
    
    
    func QuquestionDone(){
        if AnswerArray[selecteledSubject].contains(where: {$0.qno == (selecteled+1)}){
            if let index = AnswerArray[selecteledSubject].firstIndex(where:{$0.qno == (selecteled+1)}){
                let item = AnswerArray[selecteledSubject][index]
                var tag = -1
                if item.isSaved {
                    tag = getOPtionTag(option: item.lastSaved)
                }else{
                    if let value = item.selectedOption{
                        tag = getOPtionTag(option: value)
                    }else{
                        tag = -1
                    }
                }
                
                if tag >= 0{
                    let view = radioArray[tag]
                    view.circle.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.5019607843, alpha: 1)
                    view.option.textColor = .black
                    
                }
            }
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
           if #available(iOS 13.0, *) {
               return .darkContent
           } else {
               return .default
           }
       }
    @IBAction func reloadbtn(_ sender: UIButton){
        self.rotateImage1(image: reload, angle: 180)
        loadData(index: selecteled)
        self.reload.transform = .identity
        
    }
    @IBAction func answerSelected(_ sender:UIButton){
        clearSaveReviewBtn()
       // if !AnswerArray[selecteledSubject].contains(where: {$0.qno == (selecteled+1)}){
            setinitialvalues()
            let view = radioArray[sender.tag]
            view.circle.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.5019607843, alpha: 1)
            view.option.textColor = .black
            checkAnswer(option: sender.titleLabel?.text ?? "")
            
        //}
    }
    
    func checkAnswer(option:String){
        let answerObj = AnswerSelected()
        if let answer = mcqsData[selecteled].answers?[0].correctAnswer{
          
           // AnswerArray[selecteledSubject].append(answerObj)
            
           if AnswerArray[selecteledSubject].contains(where: {$0.qno == (selecteled+1)}){
            if let index = AnswerArray[selecteledSubject].firstIndex(where:{$0.qno == (selecteled+1)}){
                AnswerArray[selecteledSubject][index].selectedOption = option
            }
           }else{
            answerObj.qno = selecteled+1
            answerObj.correctOption = answer
            answerObj.selectedOption = option
            answerObj.subject = selecteledSubject
           
            if option == answer{
                
                answerObj.isCheck = true
            }else{
                
                answerObj.isCheck = false
            }
            
            answerObj.isSaved = false
            answerObj.isReviewed = false
            AnswerArray[selecteledSubject].append(answerObj)
        }
            
        }
        
    }
    @IBAction func reviewQuestionPressed(_ sender:UIButton){
        setReviewBtn()
        if AnswerArray[selecteledSubject].contains(where: {$0.qno == (selecteled+1)}){
         if let index = AnswerArray[selecteledSubject].firstIndex(where:{$0.qno == (selecteled+1)}){
            AnswerArray[selecteledSubject][index].isReviewed = true
            let option = AnswerArray[selecteledSubject][index].selectedOption
            AnswerArray[selecteledSubject][index].lastReviewed = option
//            AnswerArray[selecteledSubject][index].isSaved = false
//            setAttemptedQuestion()
         }
        }else{
                let answerObj = AnswerSelected()
                answerObj.qno = selecteled + 1
                answerObj.subject = selecteledSubject
                answerObj.isSaved = false
                answerObj.isReviewed = true
                AnswerArray[selecteledSubject].append(answerObj)
            
        }
    }
    @IBAction func hideReviewList(_ sender:UIButton){
        self.reviewListView.isHidden = true
    }
    
    func clearSaveReviewBtn(){
        saveButton.backgroundColor = .white
        saveButton.setTitleColor(#colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.5019607843, alpha: 1), for: .normal)
        reviewButton.backgroundColor = .white
        reviewButton.setTitleColor(#colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.5019607843, alpha: 1), for: .normal)
    }
    func setReviewBtn(){
        saveButton.backgroundColor = .white
        saveButton.setTitleColor(#colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.5019607843, alpha: 1), for: .normal)
        reviewButton.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.5019607843, alpha: 1)
        reviewButton.setTitleColor(.white, for: .normal)
    }
    func setSaveBtn(){
        saveButton.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.5019607843, alpha: 1)
        saveButton.setTitleColor(.white, for: .normal)
        reviewButton.backgroundColor = .white
        reviewButton.setTitleColor(#colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.5019607843, alpha: 1), for: .normal)
    }
    @IBAction func saveQuestionPressed(_ sender:UIButton){
        if AnswerArray[selecteledSubject].contains(where: {$0.qno == (selecteled+1)}){
         if let index = AnswerArray[selecteledSubject].firstIndex(where:{$0.qno == (selecteled+1)}){
            setSaveBtn()
            AnswerArray[selecteledSubject][index].isSaved = true
            AnswerArray[selecteledSubject][index].isReviewed = false
            let option = AnswerArray[selecteledSubject][index].selectedOption
            AnswerArray[selecteledSubject][index].lastSaved = option
            if let answer = mcqsData[selecteled].answers?[0].correctAnswer{
                if option == answer{
                    
                    AnswerArray[selecteledSubject][index].isCheck = true
                }else{
                    
                    AnswerArray[selecteledSubject][index].isCheck = false
                }
            }
         }
            setAttemptedQuestion()
        }
    }
    func setAttemptedQuestion(){
        var count = 0
        for subjectList in AnswerArray{
            let savedQuestion = subjectList.filter({$0.isSaved}).count
            count += savedQuestion
        }
        self.attemptedcounter.text = "\(count)/\(getCountTotalQuestion())"
    }
    @IBAction func showReviewList(_ sender:UIButton){
        reviewList = []
        for subjectList in AnswerArray{
            let list = subjectList.filter({$0.isReviewed})
            reviewList.append(contentsOf: list)
        }
        self.reviewListTableView.reloadData()
        self.reviewListView.isHidden = false
    }
    @IBAction func nextPress(_ sender : UIButton){
        let count = mcqsData.count
        if selecteled < count - 1 {
            setinitialvalues()
            
            selecteled += 1
            QuquestionDone()
            
            isAnswerSelect = false
            
            loadData(index: selecteled)
        }else{
            if let subjectlist = SubjectData{
                let count = subjectlist.count
                if selecteledSubject < (count-1){
                    selecteledSubject += 1
                     let item =  subjectlist[selecteledSubject]
                        if let index = testData?.firstIndex(where: {$0.courseID == item.courseID}){
                            mcqsData = mcqsList[index]
                            selecteled = 0
                            setinitialvalues()
                            QuquestionDone()
                            loadData(index: selecteled)
                            subjectName.text = subjectlist[selecteledSubject].courseID ?? ""
                            
                            collectionView.reloadData()
                        }
                    
                }
            }
        }
    }
    @IBAction func moveToNextSubject(_ sender: UIButton){
        if let subjectlist = SubjectData{
            let count = subjectlist.count
            if selecteledSubject < (count-1){
                selecteledSubject += 1
                 let item =  subjectlist[selecteledSubject]
                    if let index = testData?.firstIndex(where: {$0.courseID == item.courseID}){
                        mcqsData = mcqsList[index]
                        selecteled = 0
                        setinitialvalues()
                        QuquestionDone()
                        loadData(index: selecteled)
                        subjectName.text = subjectlist[selecteledSubject].courseID ?? ""
                        
                        collectionView.reloadData()
                    }
                
            }
        }
    }
    @IBAction func moveToPreviceSubject(_ sender: UIButton){
        if let subjectlist = SubjectData{
            
            if selecteledSubject > 0{
                selecteledSubject -= 1
                 let item =  subjectlist[selecteledSubject]
                    if let index = testData?.firstIndex(where: {$0.courseID == item.courseID}){
                        mcqsData = mcqsList[index]
                        selecteled = 0
                        setinitialvalues()
                        QuquestionDone()
                        loadData(index: selecteled)
                        subjectName.text = subjectlist[selecteledSubject].courseID ?? ""
                        
                        collectionView.reloadData()
                    }
                
            }
        }
    }
    
    @IBAction func moveToLastQuestion(_ sender: UIButton){
        if let subjectlist = SubjectData{
            let count = subjectlist.count
                selecteledSubject =  (count-1)
                 let item =  subjectlist[selecteledSubject]
                    if let index = testData?.firstIndex(where: {$0.courseID == item.courseID}){
                        mcqsData = mcqsList[index]
                        let totalSubjectMcqs = mcqsData.count
                        selecteled = (totalSubjectMcqs-1)
                        setinitialvalues()
                        QuquestionDone()
                        loadData(index: selecteled)
                        subjectName.text = subjectlist[selecteledSubject].courseID ?? ""
                        
                        collectionView.reloadData()
                    }
                
            }
        
    }
    
    @IBAction func moveToFirstQuestion(_ sender: UIButton){
        if let subjectlist = SubjectData{
            
                selecteledSubject =  0
                 let item =  subjectlist[selecteledSubject]
                    if let index = testData?.firstIndex(where: {$0.courseID == item.courseID}){
                        mcqsData = mcqsList[index]
                        selecteled = 0
                        setinitialvalues()
                        QuquestionDone()
                        loadData(index: selecteled)
                        subjectName.text = subjectlist[selecteledSubject].courseID ?? ""
                        collectionView.reloadData()
                    }
                
            }
        
    }
    
    func finishTest(){
        if let data =  SubjectData{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
            vc.SubjectData = data
            vc.testData = self.testData
            vc.AnswerArray = self.AnswerArray
            vc.mcqsList = self.mcqsList
            vc.date =  self.dateDay.text ?? ""
            vc.day = self.dayName.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func showAcknownlegdeView (_ sender: UIButton){
        acknowledgeView.isHidden = false
    }
    @IBAction func gotoResult (_ sender: UIButton){
        finishTest()
    }
    @IBAction func hideAcknownlegdeView(_ sender: UIButton){
        acknowledgeView.isHidden = true

    }
    func setinitialvalues(){
        for view in radioArray{
            view.circle.backgroundColor = .clear
            view.option.textColor = .white
        }
    }
    @IBAction func previosPress(_ sender : UIButton){
        if selecteled > 0{
            setinitialvalues()
            selecteled -= 1
            isAnswerSelect = false
            
            QuquestionDone()
            loadData(index: selecteled)
        }else{
            if let subjectlist = SubjectData{
                
                if selecteledSubject > 0{
                    selecteledSubject -= 1
                     let item =  subjectlist[selecteledSubject]
                        if let index = testData?.firstIndex(where: {$0.courseID == item.courseID}){
                            mcqsData = mcqsList[index]
                            selecteled = (mcqsData.count - 1)
                            setinitialvalues()
                            QuquestionDone()
                            loadData(index: selecteled)
                            subjectName.text = subjectlist[selecteledSubject].courseID ?? ""
                            
                            collectionView.reloadData()
                        }
                    
                }
            }
        }
    }
    @IBAction func backPressed(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func sideMenu(sender:UIButton){
        makeRightSideMenu(sender: sender)
    }
    @IBAction func morePressed(_ sender : UIButton){
        if   let strUrl = mcqsData[selecteled].questionText{
            //               let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //                let vc = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
            //            vc.webString = strUrl
            //
            //                self.navigationController?.present(vc, animated: true, completion: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
            vc.webString = strUrl
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension TestViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SubjectData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestSubjectCell", for: indexPath) as! TestSubjectCell
        if let item =  SubjectData?[indexPath.item]{
            if indexPath.item == selecteledSubject{
                if let image = UIImage(named: "\(item.courseID ?? "")Enable"){
                cell.subjectImage.image = image
                }else{
                    cell.subjectImage.image = UIImage(named: "ic_dbtest")
                }
                cell.circleView.borderColor = getColor(subject: item.courseID ?? "")
            }else{
                if let image = UIImage(named: "\(item.courseID ?? "")Disable"){
                cell.subjectImage.image = image
                }else{
                    cell.subjectImage.image = UIImage(named: "ic_dbtestw")
                }
                cell.circleView.borderColor = .darkGray
            }
            cell.subject.text = item.courseID ?? ""
            cell.line.isHidden = true
            return cell
            
            
        }
        return UICollectionViewCell()
    }
    func getColor(subject:String)->UIColor{
        if subject == "Chemistry" || subject == "Computer Science"{
            return #colorLiteral(red: 0.9594212174, green: 0.5037184954, blue: 0.192730844, alpha: 1)
        }else if subject == "Physics"{
            return #colorLiteral(red: 0.9889493585, green: 0.7062146068, blue: 0.3130962253, alpha: 1)
        }else if subject == "Mathematics" || subject == "Biology" || subject == "G. Mathematics"{
            return #colorLiteral(red: 0.3021526039, green: 0.4153817296, blue: 0.7058065534, alpha: 1)
        }else if subject == "English"{
            return #colorLiteral(red: 0.5087519884, green: 0.785035789, blue: 0.5360324383, alpha: 1)
        }
        
        return .darkGray
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item =  SubjectData?[indexPath.item]{
            if let index = testData?.firstIndex(where: {$0.courseID == item.courseID}){
                mcqsData = mcqsList[index]
                selecteled = 0
                setinitialvalues()
                selecteledSubject = indexPath.item
                QuquestionDone()
                loadData(index: 0)
                subjectName.text = SubjectData?[indexPath.item].courseID ?? ""
                
                collectionView.reloadData()
            }
        }
        
        
        
        //  self.counter.text = "\(selecteled+1)/\(mcqsData.count)"
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets  {
        
        //Where elements_count is the count of all your items in that
        //Collection view...
        
        let numberofcell = (SubjectData?.count) ?? 0
        let cellCount = CGFloat(numberofcell)
        
        //If the cell count is zero, there is no point in calculating anything.
        if cellCount > 0 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            print(flowLayout.minimumInteritemSpacing)
            print(flowLayout.itemSize.width )
            let cellWidth = CGFloat(85) //+ //flowLayout.minimumInteritemSpacing
            
            //20.00 was just extra spacing I wanted to add to my cell.
            
            
            let  totalCellWidth = cellWidth * cellCount
            
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
            
            if (totalCellWidth < contentWidth) {
                //If the number of cells that exists take up less room than the
                //collection view width... then there is an actual point to centering them.
                
                //Calculate the right amount of padding to center the cells.
                let padding = (contentWidth - totalCellWidth) / 2.0
                print(padding)
                return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
            } else {
                //Pretty much if the number of cells that exist take up
                //more room than the actual collectionView width, there is no
                // point in trying to center them. So we leave the default behavior.
                // return UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
            }
        }
        
        return UIEdgeInsets.zero
    }
}
extension TestViewController{ // for api calling
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }
    func startTestTime(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(transToHourMinSec), userInfo: nil, repeats: true)
    }
    
    @objc func countdown() {
        var hours: Int
        var minutes: Int
        var seconds: Int
        
        
        totalSecond = totalSecond + 1
        hours = totalSecond / 3600
        minutes = (totalSecond % 3600) / 60
        seconds = (totalSecond % 3600) % 60
        
        if hours <= 0{
            timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
            
        }else{
            timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            
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
                        if let value = jsonObject, value.count > 0
                        {
                            
                            self.detailData =  value[0]
                            DispatchQueue.main.async {
                                self.setLablValues(date: self.detailData.dated ?? "")
                                self.parseData()
                                
                                
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
    
    func parseData(){
        if let jsonObject =  detailData.workSheet?.data(using: .utf8)!{
            do {
                let data = try JSONDecoder().decode([WorkSheetModel].self, from: jsonObject)
                SubjectData = []
                AnswerArray = []
                for obj in data{
                    if obj.type == self.type{
                        let ansswer = [AnswerSelected]()
                        AnswerArray.append(ansswer)
                        self.SubjectData?.append(obj)
                    }
                }
                if let item = SubjectData?[0]{
                    if let title = item.title{
                        callingApi(testid: title, workid: workId)
                    }
                }
                collectionView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    func callingApi(testid:String,workid:String){
        //        if ReachabilityManager.isNetworkConnected()
        //        {
        if (self.isInternetConnected())
        {
            CustomLoader.instance.showLoaderView()
            
            let url = "\(HTTP.BaseUrl)Work/GetTest"
            print("URL: ",url)
            
            postManagerUser(method: "POST", isThisURLEmbdedData: false, urlString: url, parameter: ["TestId":testid,"WorkDayId":workid], success: {(value) in
                do
                {
                    let jsonObject = try JSONDecoder().decode([WorkSheetElementModel]?.self, from: value)
                    DispatchQueue.main.async {
                        if let value = jsonObject , value.count > 0
                        {
                            DispatchQueue.main.async {
                                for test in value{
                                    self.parseDataMcqs(data: test)
                                }
                                self.testData = value
                                //self.tableView.reloadData()
                                if self.mcqsList.count > 0{
                                    if let item =  self.SubjectData?[0]{
                                    
                                        if let duration = value[0].duration , duration > 0{
                                            self.remainingSeconds = (duration*60)
                                           // self.remainingSeconds = 5
                                            self.startTestTime()
                                        }else{
                                            self.startTimer()
                                        }
                                        if let index = self.testData?.firstIndex(where: {$0.courseID == item.courseID}){
                                            self.mcqsData = self.mcqsList[index]
                                            self.loadData(index: self.selecteled)
                                            self.attemptedcounter.text = "0/\(self.getCountTotalQuestion())"
                                            self.subjectName.text = self.SubjectData?[0].courseID ?? ""
                                        }}
                                    
                                }
                            }
                        }else{
                            print("No data")
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
    
    
    func parseDataMcqs(data:WorkSheetElementModel){
        if let jsonObject =  data.mcqs?.data(using: .utf8)!{
            do {
                let data = try JSONDecoder().decode([Mcq].self, from: jsonObject)
                var tempMcqsData = [Mcq]()
                for obj in data{
                    //if obj.isEnable == 1{
                        tempMcqsData.append(obj)
//                    }else{
//                        print("not")
//                    }
                }
                mcqsList.append(tempMcqsData)
                // tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    func loadData(index: Int){
        clearSaveReviewBtn()
        let count =  mcqsData.count
        if count > 0{
            
            
            //        if (getPreviousTotalQuestion()-1+index) == 0 {
            //             previousButton.setImage(UIImage(named: "ic_test_arrowback_disable"), for: .normal)
            //            previousButton.isEnabled = false
            //        }else if (getPreviousTotalQuestion() + index) == getCountTotalQuestion() {
            //            nextButton.setImage(UIImage(named: "ic_test_right_disable"), for: .normal)
            //            nextButton.isEnabled = false
            //        }else{
            //            previousButton.setImage(UIImage(named: "ic_test_arrowleft"), for: .normal)
            //            nextButton.setImage(UIImage(named: "ic_test_arrowright"), for: .normal)
            //            nextButton.isEnabled = true
            //            previousButton.isEnabled = true
            //        }
            if index == 0 && selecteledSubject == 0 {
                        previousButton.setImage(UIImage(named: "ic_test_arrowback_disable"), for: .normal)
                        previousButton.isEnabled = false
                        nextButton.setImage(UIImage(named: "ic_test_arrowright"), for: .normal)
                        nextButton.isEnabled = true
            }else if index == (count-1) {
                
                if let subjectlist = SubjectData{
                    let count = subjectlist.count
                    if selecteledSubject == (count-1){
                        nextButton.setImage(UIImage(named: "ic_test_right_disable"), for: .normal)
                        nextButton.isEnabled = false
                        previousButton.isEnabled = true
                        previousButton.setImage(UIImage(named: "ic_test_arrowleft"), for: .normal)
                    }
                }
                
    
                
            }else{
                previousButton.setImage(UIImage(named: "ic_test_arrowleft"), for: .normal)
                nextButton.setImage(UIImage(named: "ic_test_arrowright"), for: .normal)
                nextButton.isEnabled = true
                previousButton.isEnabled = true
            }
            
           
            if let subjectlist = SubjectData{
                let count = subjectlist.count
                if selecteledSubject == (count-1){
                    previousSubjectButton.setImage(UIImage(named: "ic_arrow2l"), for: .normal)
                    nextSubjecttButton.setImage(UIImage(named: "ic_arrow2rdisable"), for: .normal)
                }else  if selecteledSubject == 0{
                    previousSubjectButton.setImage(UIImage(named: "ic_arrow2ldisable"), for: .normal)
                    nextSubjecttButton.setImage(UIImage(named: "ic_arrow2r"), for: .normal)
                }else{
                    previousSubjectButton.setImage(UIImage(named: "ic_arrow2l"), for: .normal)
                    nextSubjecttButton.setImage(UIImage(named: "ic_arrow2r"), for: .normal)
                }
            }
            
            if   let strUrl = mcqsData[index].questionText{
                let arrayUrl = strUrl.split(separator: ">")
                print(arrayUrl.count)
                if arrayUrl.count > 0{
                    if arrayUrl.count == 1{
                        moreButton.isHidden = true
                    }else{
                        moreButton.isHidden = false
                        
                    }
                    var img = "\(arrayUrl[0])"
                    //.split(separator: "=",maxSplits: 1)[1]
                    // img = img.substring(from: "<", to: ">")
                    //  img = "\(img.split(separator: "=",maxSplits: 1)[1])"
                    img = "\(img.split(separator: "=",maxSplits: 1)[1])"
                    img = img.replacingOccurrences(of: "\\\\", with: "")
                    img = img.replacingOccurrences(of: "\"", with: "")
                    img = img.replacingOccurrences(of: "\\n", with: "")
                    img = img.replacingOccurrences(of: "\n", with: "")
                    img = img.replacingOccurrences(of: "\\", with: "")
                    if img.last == "/"{
                        img.removeLast()
                    }
                    img = img.trimmingCharacters(in: .whitespaces)
                    img = img.replacingOccurrences(of: " ", with: "%20")
                    
                    if let url =  URL(string: img){
                        // current Question
                        
                        self.counter.text = "\(selecteled+getPreviousTotalQuestion())"
                        totalConter = selecteled+getPreviousTotalQuestion()
                        
                        //  self.webView.loadHTMLString("<html><body style=\"background-color: transparent;\"><img src=\"\(url)\" style=\"background-color: transparent;\"></body></html>", baseURL: nil )
                        DispatchQueue.main.async {
                            self.webView.load(URLRequest(url: url))
                            
                            
                        }
                    }
                    else{
                        POPUp(message: "Url Error", time: 1.8)
                    }
                }
            }
        }
    }
    
    
    func getCountTotalQuestion()->Int{
        
        var total = 0
        for mcqs in mcqsList{
            total += mcqs.count
        }
        return total
    }
    
    
    func getPreviousTotalQuestion()->Int{
        
        var total = 0
        if selecteledSubject != 0{
            for i in 0...selecteledSubject - 1 {
                if let item =  SubjectData?[i]{
                    if let index = testData?.firstIndex(where: {$0.courseID == item.courseID}){
                        total += mcqsList[index].count
                    }
                }
            }
            return total + 1
        }
        return  1
    }
    func getPreviousTotalQuestion(subject:Int)->Int{
        
        var total = 0
        if subject != 0{
            for i in 0...subject - 1 {
                if let item =  SubjectData?[i]{
                    if let index = testData?.firstIndex(where: {$0.courseID == item.courseID}){
                        total += mcqsList[index].count
                    }
                }
            }
            return total + 1
        }
        return  1
    }
}
extension TestViewController:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activitControler.isHidden = false
        
        activitControler.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        activitControler.isHidden = true
        activitControler.stopAnimating()
    }
  
}

extension TestViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewMainCell") ?? UITableViewCell()
            return cell
        }else
            
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewCell
            let item = reviewList[indexPath.row-1]
            
            let qno = item.qno + getPreviousTotalQuestion(subject: item.subject)
            cell.questionNo.text = "\(qno-1)"
            if let subjectlist = SubjectData{
            cell.subject.text = subjectlist[item.subject].courseID
            }else{
                cell.subject.text = ""
            }
            if let option = item.lastReviewed{
                cell.selectedOption.text = "\(option)"
            }else{
                cell.selectedOption.text = ""
            }
       
            if indexPath.row == (tableView.numberOfRows(inSection: indexPath.section) - 1){
                cell.lineView.isHidden = true
            }else{
                cell.lineView.isHidden = false
                
            }
            return cell
            
        }
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        let item = reviewList[indexPath.row-1]
        if let mainItem =  SubjectData?[item.subject]{
            if let index = testData?.firstIndex(where: {$0.courseID == mainItem.courseID}){
                mcqsData = mcqsList[index]
                selecteledSubject = item.subject
                selecteled = (item.qno-1)
                setinitialvalues()
                QuquestionDone()
                loadData(index: selecteled)
                self.reviewListView.isHidden = true
                subjectName.text = SubjectData?[item.subject].courseID ?? ""
                self.collectionView.reloadData()
            }
        }
        
    }
  @objc func transToHourMinSec()
    {
        if self.remainingSeconds == 0{
            timer?.invalidate()
          finishTest()
        }else{
            
        let allTime: Int = remainingSeconds
        var hours = 0
        var minutes = 0
        var seconds = 0
        var hoursText = ""
        var minutesText = ""
        var secondsText = ""
        
        hours = allTime / 3600
        hoursText = hours > 9 ? "\(hours)" : "0\(hours)"
        
        minutes = allTime % 3600 / 60
        minutesText = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        seconds = allTime % 3600 % 60
        secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"
            self.timeLabel.text = "\(hoursText):\(minutesText):\(secondsText)"
            remainingSeconds -= 1
        }
         
    }

}
