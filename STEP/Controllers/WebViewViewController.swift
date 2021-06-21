//
//  ViewControllerweb.swift
//  STEP
//
//  Created by apple on 30/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import WebKit
class WebViewViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var tableView: UITableView!
    var webViewList : [WKWebView]?
    var urlString : [URL]?
    var webString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        
        if   let strUrl = webString{
            let arrayUrl = strUrl.split(separator: ">")
            print(arrayUrl.count)
            if arrayUrl.count > 0{
                
                urlString = []
                webViewList = []
                
                for line in arrayUrl{
                    if line.count > 0{
                        let wk = WKWebView()
                        wk.navigationDelegate = self
                        webViewList?.append(wk)
                    }
                }
                var tag = 0
                
                if isInternetConnected()
                {
                    
                    for line in arrayUrl{
                        CustomLoader.instance.showLoaderView()
                        if line.count > 5 && line.contains("="){
                            let strUrl = geturl(str: "\(line)")
                            if let url =  URL(string: strUrl){
                                urlString?.append(url)
                                webViewList?[tag].tag = tag
                                webViewList?[tag].load(URLRequest(url: url))
                                tag += 1
                            }else{
                                CustomLoader.instance.hideLoaderView()
                                // POPUp(message: "Url Error", time: 1.8)
                            }
                        }else{
                            CustomLoader.instance.hideLoaderView()
                        }
                    }
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
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(webView.tag)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.tag == (webViewList?.count ?? -1 )-1{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                CustomLoader.instance.hideLoaderView()
                self.tableView.reloadData()
            })
        }
        tableView.reloadData()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func geturl(str:String)->String{
        var img = str//.split(separator: "=",maxSplits: 1)[1]
        // img = img.substring(from: "<", to: ">")
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
        
        return img
    }
    
    @IBAction func backPressed(_ sender : UIButton){
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
}

extension WebViewViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlString?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WebCell
        if let view = webViewList?[indexPath.row]{
            
            
            view.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: view.scrollView.contentSize.height)
            cell.viewWeb.addSubview(view)
            cell.height.constant = view.scrollView.contentSize.height + 20
            
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        if( webViewList?[indexPath.row].scrollView.contentSize.height ?? 0 ) < 50.0{
        //
        //            tableView.reloadData()
        //        }
        //        return webViewList?[indexPath.row].scrollView.contentSize.height ?? 200
        return UITableView.automaticDimension
    }
    
}


