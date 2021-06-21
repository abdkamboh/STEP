//
//  DetailVocabularyViewController.swift
//  STEP
//
//  Created by apple on 09/06/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import WebKit

class DetailVocabularyViewController: UIViewController {
    
    var wordList = [VocabularyModel]()
    
    var selectedword : VocabularyModel?
    var selectedIndex = -1
    
    @IBOutlet weak var webView : WKWebView!
    @IBOutlet weak var previosBtn:UIButton!
    @IBOutlet weak var sideMenuBtn:UIButton!

    @IBOutlet weak var nextBtn:UIButton!
    @IBOutlet weak var wordLbl:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        webView.navigationDelegate = self
         self.wordList = self.wordList.sorted { $0.word! < $1.word! }
        if let item = selectedword{
            selectedIndex = getIndex(list: wordList, item: item)
            if selectedIndex != -1{
                lodData(index: selectedIndex)
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func sideMenu(sender:UIButton){
          makeRightSideMenu(sender: sender)
      }
    @IBAction func nextPress(_ sender : UIButton){
        let count = wordList.count
        if selectedIndex < count - 1 {
            selectedIndex += 1
            lodData(index: selectedIndex)
        }
    }
    @IBAction func previosPress(_ sender : UIButton){
         if selectedIndex > 0{
             selectedIndex -= 1
             lodData(index: selectedIndex)
         }
     }
    @IBAction func backPressed(_ sender : UIButton){
           self.navigationController?.popViewController(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func getIndex (list:[VocabularyModel],item:VocabularyModel)-> Int{
        var index = -1
        for worditem in list{
            if worditem.word == item.word{
                index = index + 1
                return index
            }
            index += 1
        }
        return -1
    }
    
    func lodData(index: Int){
        let count =  wordList.count
        if count > 0{
            if count == 1{
                previosBtn.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 1, alpha: 1)
                previosBtn.setTitleColor(#colorLiteral(red: 0.5607843137, green: 0.5921568627, blue: 0.6392156863, alpha: 1), for: .normal)
                previosBtn.isEnabled = false
                nextBtn.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 1, alpha: 1)
                nextBtn.setTitleColor(#colorLiteral(red: 0.5607843137, green: 0.5921568627, blue: 0.6392156863, alpha: 1), for: .normal)
                nextBtn.isEnabled = false
            }else if index == 0 {
                previosBtn.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 1, alpha: 1)
                previosBtn.setTitleColor(#colorLiteral(red: 0.5607843137, green: 0.5921568627, blue: 0.6392156863, alpha: 1), for: .normal)
                previosBtn.isEnabled = false
            }else if index == count - 1{
                nextBtn.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.968627451, blue: 1, alpha: 1)
                nextBtn.setTitleColor(#colorLiteral(red: 0.5607843137, green: 0.5921568627, blue: 0.6392156863, alpha: 1), for: .normal)
                nextBtn.isEnabled = false
            }else{
                previosBtn.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.8980392157, blue: 1, alpha: 1)
                previosBtn.setTitleColor(#colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.5019607843, alpha: 1), for: .normal)
                nextBtn.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.8980392157, blue: 1, alpha: 1)
                nextBtn.setTitleColor(#colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.5019607843, alpha: 1), for: .normal)
                previosBtn.isEnabled = true
                nextBtn.isEnabled = true
            }
            if let strUrl = wordList[index].link{
                var img = "\(strUrl.split(separator: "=",maxSplits: 1)[1])"
                img = img.replacingOccurrences(of: "\"", with: "")
                img = img.replacingOccurrences(of: ">", with: "")
                img = img.replacingOccurrences(of: "\\n", with: "")
                img = img.replacingOccurrences(of: "\n", with: "")
                img = img.replacingOccurrences(of: "\\", with: "")
                img = img.trimmingCharacters(in: .whitespaces)
                img = img.replacingOccurrences(of: " ", with: "%20")
                if let url =  URL(string: img){
                    self.wordLbl.text = wordList[index].word ?? ""
                    //  self.webView.loadHTMLString("<html><body style=\"background-color: transparent;\"><img src=\"\(url)\" style=\"background-color: transparent;\"></body></html>", baseURL: nil )
                    DispatchQueue.main.async {
                        self.wordLbl.text = self.wordList[index].word ?? ""
                        self.webView.load(URLRequest(url: url))
                    }
                }
                else{
                    POPUp(message: "Url Error", time: 1.8)
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
}
extension DetailVocabularyViewController:WKNavigationDelegate{
 func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
     
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
     
    }
}

