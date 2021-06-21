//
//  VocabularyViewController.swift
//  STEP
//
//  Created by apple on 09/06/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class VocabularyViewController: UIViewController,UITextFieldDelegate {
    var vocabularyList = [VocabularyModel]()
    var searchData: [VocabularyModel] = []
    var search : String = ""
    var programId = ""
    @IBOutlet weak var searchBtn:UIButton!
    @IBOutlet weak var sideMenuBtn:UIButton!
    @IBOutlet weak var navTitle:UILabel!
    @IBOutlet weak var searchView:UIView!
    @IBOutlet weak var searchTextField:UITextField!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var wheelImage : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        searchTextField.delegate = self
        callingApi(pid: programId)
        tableView.delegate = self
        tableView.dataSource = self
        
        wheelImage.startRotateBy(angle: -(Double.pi/2))

        // Do any additional setup after loading the view.
    }
    @IBAction func sideMenu(sender:UIButton){
          makeRightSideMenu(sender: sender)
      }
    @IBAction func searchPressed(_ sender:UIButton){
  
        searchTextField.becomeFirstResponder()
        setViews(bool: true)
    }
    @IBAction func searchClosePrssed(_ sender:UIButton){

        searchTextField.resignFirstResponder()
          setViews(bool: false)
        searchData = vocabularyList
          searchData = searchData.sorted { $0.orderNo! < $1.orderNo! }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override var preferredStatusBarStyle: UIStatusBarStyle {
           if #available(iOS 13.0, *) {
               return .darkContent
           } else {
               return .default
           }
       }
}
extension VocabularyViewController{
    
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
      
        let arr = vocabularyList.filter{(x) -> Bool in
            (x.word?.lowercased().contains(search.lowercased()))!
        }

        if arr.count > 0
        {
            searchData.removeAll(keepingCapacity: true)
            searchData = arr
            searchData = searchData.sorted { $0.orderNo! < $1.orderNo! }
        }
        else
        {
            searchData=[]
        }
        if search == ""{
            searchData = vocabularyList
            searchData = searchData.sorted { $0.orderNo! < $1.orderNo! }
        }
        tableView.reloadData()
        return true
    }
    func callingApi(pid:String)  {
        //        if ReachabilityManager.isNetworkConnected()
        //        {
        if (self.isInternetConnected())
        {
            CustomLoader.instance.showLoaderView()
            
            let url = "\(HTTP.BaseUrl)Work/GetVocabulary"
            print("URL: ",url)
            
            postManagerUser(method: "POST", isThisURLEmbdedData: false, urlString: url, parameter: ["ProgramId":pid], success: {(value) in
                do
                {
                    let jsonObject = try JSONDecoder().decode([VocabularyModel]?.self, from: value)
                    DispatchQueue.main.async {
                        if let value = jsonObject
                        {
                            DispatchQueue.main.async {
                                self.vocabularyList = value
                                self.searchData = self.vocabularyList
                                self.searchData = self.searchData.sorted { $0.orderNo! < $1.orderNo! }
                                self.tableView.reloadData()
                                
                                
                                //self.tableView.reloadData()
                            }
                        }else{
                            DispatchQueue.main.async {
                                self.POPUp(message: "No data found", time: 1.8)
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

extension VocabularyViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searchData[indexPath.row].orderNo == 0{
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "VocabularyCell") as! VocabularyCell
    

        cell.word.text = searchData[indexPath.row].word ?? ""
        cell.number.text = "\(indexPath.row + 1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailVocabularyViewController") as! DetailVocabularyViewController
        vc.wordList = searchData
        vc.selectedword = searchData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
                searchTextField.resignFirstResponder()
    }
    
}
