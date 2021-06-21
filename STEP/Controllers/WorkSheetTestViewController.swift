//
//  TestViewController.swift
//  STEP
//
//  Created by apple on 26/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import WebKit
class WorkSheetTestViewController: UIViewController {
    var testId = ""
    var day = ""
    var date = ""
    var selecteled = 0
    var testData : WorkSheetElementModel?
    var mcqsData : [Mcq]?
    var AnswerArray = [AnswerSelected]()
    
    var answerList = ["A","B","C","D"]
    @IBOutlet weak var wheelImage : UIImageView!
    @IBOutlet weak var reload : UIImageView!
    @IBOutlet weak var activitControler : UIActivityIndicatorView!
    @IBOutlet weak var dayName : UILabel!
    @IBOutlet weak var titleNavBar : UILabel!
    @IBOutlet weak var dateDay : UILabel!
    @IBOutlet weak var lineView : UIView!
    @IBOutlet weak var viewForWeb : UIView!
    // var webView = WKWebView()
    @IBOutlet weak var explainBtn : UIButton!
    
    @IBOutlet weak var webView : WKWebView!
    @IBOutlet weak var nextButton : UIButton!
    @IBOutlet weak var previousButton : UIButton!
    @IBOutlet weak var moreButton : UIButton!
    @IBOutlet weak var subjectName : UILabel!
    @IBOutlet weak var counter : UILabel!
    @IBOutlet weak var stackView : UIStackView!
    @IBOutlet weak var timeLabel : UILabel!
    
    @IBOutlet weak var radioButtoA : RadioButtonView!
    @IBOutlet weak var radioButtoB : RadioButtonView!
    @IBOutlet weak var radioButtoC : RadioButtonView!
    @IBOutlet weak var radioButtoD : RadioButtonView!
    
    @IBOutlet weak var CorrectAnswerIs : UILabel!
    @IBOutlet weak var CorrectView : UIView!
    @IBOutlet weak var wrongView : UIView!
    
    var radioArray = [RadioButtonView]()
    var isAnswerSelect = false
    var totalSecond = Int()
    var timer : Timer?
    override func viewDidAppear(_ animated: Bool) {
        // timer?.invalidate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dayName.text = day
        dateDay.text = date
       wheelImage.startRotateBy(angle: -(Double.pi/2))
        radioArray = [radioButtoA,radioButtoB,radioButtoC,radioButtoD]
        
        webView.navigationDelegate = self
        webView.clearBackgrounds()
        
        //        webView = WKWebView()
        //        webView.frame = viewForWeb.frame
        //  webView = WKWebView(frame: self.viewForWeb.frame)
        //   self.viewForWeb.addSubview(webView)
        callingApi(testid: testId)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backPressed(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sideMenu(sender:UIButton){
        makeRightSideMenu(sender: sender)
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
    @IBAction func answerSelected(_ sender:UIButton){
        
        setinitialvalues()
        let view = radioArray[sender.tag]
        view.circle.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.5019607843, alpha: 1)
        view.option.textColor = .black
        checkAnswer(option: sender.titleLabel?.text ?? "")
        
        
    }
    func setViews(){
        CorrectView.isHidden = true
        wrongView.isHidden = true
        CorrectAnswerIs.text = ""
    }
    func checkAnswer(option:String){
        let answerObj = AnswerSelected()
        if let answer = mcqsData?[selecteled].answers?[0].correctAnswer{
            answerObj.qno = selecteled+1
            answerObj.correctOption = answer
            explainBtn.isHidden = false
            
            answerObj.selectedOption = option
            if option == answer{
                CorrectView.isHidden = false
                wrongView.isHidden = true
                CorrectAnswerIs.text = ""
                answerObj.isCheck = true
            }else{
                CorrectView.isHidden = true
                wrongView.isHidden = false
                answerObj.isCheck = false
                CorrectAnswerIs.text = "Correct answer in \(answer)"
            }
            if AnswerArray.contains(where: {$0.qno == (selecteled+1)}){
                if let index = AnswerArray.firstIndex(where:{$0.qno == (selecteled+1)}){
                    AnswerArray[index]=answerObj
                }
            }else{
                AnswerArray.append(answerObj)
            }
        }
        
    }
    @IBAction func nextPress(_ sender : UIButton){
        
        let count = mcqsData?.count ?? -1
        if selecteled < count - 1 {
            setinitialvalues()
            explainBtn.isHidden = true
            
            selecteled += 1
            setViews()
            QuquestionDone()
            
            isAnswerSelect = false
            
            loadData(index: selecteled)
        }
    }
    
    @IBAction func reloadbtn(_ sender: UIButton){
        self.rotateImage1(image: reload, angle: 180)
        loadData(index: selecteled)
        self.reload.transform = .identity
        
    }
    
    
    func QuquestionDone(){
        
        if let index = AnswerArray.firstIndex(where:{$0.qno == (selecteled+1)}){
            let item = AnswerArray[index]
            let tag = getOPtionTag(option: item.selectedOption)
            if tag >= 0{
                explainBtn.isHidden = false
                
                let view = radioArray[tag]
                view.circle.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.5019607843, alpha: 1)
                view.option.textColor = .black
                if item.isCheck{
                    CorrectView.isHidden = false
                    wrongView.isHidden = true
                    CorrectAnswerIs.text = ""
                }else{
                    CorrectView.isHidden = true
                    wrongView.isHidden = false
                    CorrectAnswerIs.text = "Correct answer in \(item.correctOption ?? "")"
                }
            }
        }
        
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
            explainBtn.isHidden = true
            
            isAnswerSelect = false
            setViews()
            
            QuquestionDone()
            loadData(index: selecteled)
        }
    }
    
    @IBAction func explainPressed(_ sender : UIButton){
        if   let strUrl = mcqsData?[selecteled].answers?[0].answerText{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
            vc.webString = strUrl
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true, completion: nil)
           // self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func morePressed(_ sender : UIButton){
        if   let strUrl = mcqsData?[selecteled].questionText{
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
extension WorkSheetTestViewController {
    
    // timmer
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
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
    func callingApi(testid:String){
        //        if ReachabilityManager.isNetworkConnected()
        //        {
        if (self.isInternetConnected())
        {
            CustomLoader.instance.showLoaderView()
            
            let url = "\(HTTP.BaseUrl)Work/GetWorkSheet"
            print("URL: ",url)
            
            postManagerUser(method: "POST", isThisURLEmbdedData: false, urlString: url, parameter: ["TestId":testid], success: {(value) in
                do
                {
                    let jsonObject = try JSONDecoder().decode([WorkSheetElementModel]?.self, from: value)
                    DispatchQueue.main.async {
                        if let value = jsonObject, value.count > 0
                        {
                            self.testData =  value[0]
                            DispatchQueue.main.async {
                                self.subjectName.text = self.testData?.courseID ?? ""
                                self.parseData()
                                
                                
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
            //        }else{
            //           // self.Alert(message: Controller.internetConnectionMsg)
            //            self.POPUp(message: "No Internet Connection.", time: 1.8)
            //
        }
    }
    
    func parseData(){
        if let jsonObject =  testData?.mcqs?.data(using: .utf8)!{
            do {
                let data = try JSONDecoder().decode([Mcq].self, from: jsonObject)
                mcqsData = []
                for obj in data{
                    if obj.isEnable == 1{
                        self.mcqsData?.append(obj)
                    }
                }
                startTimer()
                loadData(index: selecteled)
                
            } catch {
                print(error)
            }
        }
    }
    
    func loadData(index: Int){
        let count =  mcqsData?.count ?? -1
        if count > 0{
            
            
            if index == 0{
                previousButton.setImage(UIImage(named: "ic_test_arrowback_disable"), for: .normal)
                previousButton.isEnabled = false
            }else if index == count - 1{
                nextButton.setImage(UIImage(named: "ic_test_right_disable"), for: .normal)
                nextButton.isEnabled = false
            }else{
                previousButton.setImage(UIImage(named: "ic_test_arrowleft"), for: .normal)
                nextButton.setImage(UIImage(named: "ic_test_arrowright"), for: .normal)
                nextButton.isEnabled = true
                previousButton.isEnabled = true
            }
            
            if   let strUrl = mcqsData?[index].questionText{
                let arrayUrl = strUrl.split(separator: ">")
                print(arrayUrl.count)
                if arrayUrl.count > 0{
                    if arrayUrl.count == 1{
                        moreButton.isHidden = true
                    }
                    else if arrayUrl.count == 2 && arrayUrl[1] == "\n"{
                        moreButton.isHidden = true
                    }
                    else{
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
                        
                        self.counter.text = "\(selecteled+1)/\(count)"
                        
                     
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
}

extension String {
    func stringAt(_ i: Int) -> String {
        return String(Array(self)[i])
    }
    var lines: [String] {
        var result: [String] = []
        enumerateLines { line, _ in result.append(line) }
        return result
    }
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    func substring(from left: String, to right: String) -> String {
        if let match = range(of: "(?<=\(left))[^\(right)]+", options: .regularExpression) {
            return String(self[match])
        }
        return ""
    }
}

extension WorkSheetTestViewController:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activitControler.isHidden = false
        //  stackView.isHidden = true
        activitControler.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // moreButton.isHidden = false
        //stackView.isHidden = false
        activitControler.isHidden = true
        activitControler.startAnimating()
    }
}

//F9496F red
//7ECF8B green
//B8B9D9 buuton

