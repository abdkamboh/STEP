//
//  ViewController.swift
//  STEP
//
//  Created by apple on 18/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import WebKit
import MSAL
class LoginViewController: UIViewController {
    @IBOutlet weak var wheelImage : UIImageView!
    var btnEnable = true
    var applicationContext : MSALPublicClientApplication?
    var currentAccount: MSALAccount?
    var webViewParameters : MSALWebviewParameters?
    let kClientID = "6df12fc1-bf66-4a86-92fe-52d41155bfb9"
    let kRedirectUri = "msauth.com.domainname.pgc.edu.step://auth"
    let kAuthority = "https://login.microsoftonline.com/organizations"
    let kGraphEndpoint = "https://graph.microsoft.com/"
    let kScopes: [String] = ["user.read"] // request permission to read the profile of the signed-in user
    
    var accessToken = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        do {
            try self.initMSAL()
        } catch _ {
            POPUp(message: "Microsoft Error", time: 1.8)
            // self.updateLogging(text: "Unable to create Application Context \(error)")
        }
       wheelImage.startRotateBy(angle: -(Double.pi/2))
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        btnEnable = true
        
    }
     override var preferredStatusBarStyle: UIStatusBarStyle {
             if #available(iOS 13.0, *) {
                 return .darkContent
             } else {
                 return .default
             }
         }
    
    @IBAction func LoginPressed(){
        if btnEnable {
        if (self.isInternetConnected())
        {
            btnEnable = false
            acquireTokenInteractively()
        }
        }
    }
    
    
}
extension LoginViewController{
    
    func initMSAL() throws {
        
        guard let authorityURL = URL(string: kAuthority) else {
            // self.updateLogging(text: "Unable to create authority URL")
            return
        }
        
        let authority = try MSALAADAuthority(url: authorityURL)
        
        let msalConfiguration = MSALPublicClientApplicationConfig(clientId: kClientID, redirectUri: nil, authority: authority)
        self.applicationContext = try MSALPublicClientApplication(configuration: msalConfiguration)
        self.initWebViewParams()
    }
    func initWebViewParams() {
        self.webViewParameters = MSALWebviewParameters(parentViewController: self)
    }
    func getGraphEndpoint() -> String {
        return kGraphEndpoint.hasSuffix("/") ? (kGraphEndpoint + "v1.0/me/") : (kGraphEndpoint + "/v1.0/me/");
    }
    func acquireTokenInteractively() {
        
        guard let applicationContext = self.applicationContext else { return }
        guard let webViewParameters = self.webViewParameters else { return }
        
        // #1
        let parameters = MSALInteractiveTokenParameters(scopes: kScopes, webviewParameters: webViewParameters)
        parameters.promptType = .selectAccount
        
        // #2
        applicationContext.acquireToken(with: parameters) { (result, error) in
            
            // #3
            if let error = error {
                self.Alert(title: "Warning", message: "Please complete the Microsoft authentication process to login.", text: "OK")
                self.btnEnable = true
                return
            }
            
            guard let result = result else {
                self.POPUp(message: "Could not acquire token: No result returned", time: 1.8)
                self.btnEnable = true
                return
            }
            
            // #4
            self.accessToken = result.accessToken
            
            self.getContentWithToken()
        }
    }
    func Alert(title:String = "Alert!",message:String,text:String = "OK"){
           
           DispatchQueue.main.async {
               let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

               alert.addAction(UIAlertAction(title: text, style: .cancel, handler: nil))

               self.present(alert, animated: true)
           }
       }
    func getContentWithToken() {
        
        // Specify the Graph API endpoint
        let graphURI = getGraphEndpoint()
        let url = URL(string: graphURI)
        var request = URLRequest(url: url!)
        
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                self.POPUp(message: "Couldn't get graph result: \(error)", time: 1.8)
                self.btnEnable = true
                return
            }
            
            guard let result = try? JSONSerialization.jsonObject(with: data!, options: []) else {
                self.POPUp(message: "Couldn't deserialize result JSON", time: 1.8)
                self.btnEnable = true

                //self.updateLogging(text: )
                return
            }
            let maindata = result as! [String:Any]
            // let userdata = maindata["payload_data_0"] as! [String:Any]
            let userName = maindata["userPrincipalName"] as! String
            self.callingApi(uid: userName)
        }.resume()
    }
    
    
    func callingApi(uid:String)  {
        
        if (self.isInternetConnected())
        {
            CustomLoader.instance.showLoaderView()
            
            let url = "\(HTTP.BaseUrl)Auth/External"
            print("URL: ",url)
            
            postManagerUser(method: "POST", isThisURLEmbdedData: false, urlString: url, parameter: ["Username":uid], success: {(value) in
                do
                {
                    let jsonObject = try JSONDecoder().decode(LoginModel?.self, from: value)
                    DispatchQueue.main.async {
                        if let value = jsonObject
                        {
                            DispatchQueue.main.async {
                                print(value)
                                if value.userName == "User Not Found"{
                                    self.Alert(title: "STEP", message: "User Not Found.", text: "OK")
                                     self.btnEnable = true
                                }else{
                                    if  value.varification == nil || value.varification == ""{
                                        self.signOut()
                                        self.Alert(title: "Welcome To STEP", message: "Dear Students, Your Online Test Session Classes Will Commence Soon. You Will Be Informed Timely. Stay Tuned!", text: "OK")
                                        self.btnEnable = true

                                    }else{
                                        self.saveUserData(value: value)
                                        self.gotoDashboard()
                                    }
                                }
                            }
                        }
                    }
                    
                }
                catch
                {
                    DispatchQueue.main.async {
                        self.btnEnable = true

                        self.POPUp(message: "No data found", time: 1.8)
                    }
                }
                
            }, failure: {(err) in
                
                DispatchQueue.main.async {
                    self.btnEnable = true

                    self.POPUp(message: "Something went wrong", time: 1.8)
                }
            })
            
        }
    }
    @objc func signOut() {
        
        guard let applicationContext = self.applicationContext else { return }
        
        guard let account = self.currentAccount else { return }
        
        do {
            
            /**
             Removes all tokens from the cache for this application for the provided account
             
             - account:    The account to remove from the cache
             */
            
            let signoutParameters = MSALSignoutParameters(webviewParameters: self.webViewParameters!)
            signoutParameters.signoutFromBrowser = false // set this to true if you also want to signout from browser or webview
            
            applicationContext.signout(with: account, signoutParameters: signoutParameters, completionBlock: {(success, error) in
                
                if let error = error {
                    
                }
                
                //  self.updateLogging(text: "Sign out completed successfully")
                self.accessToken = ""
                // self.updateCurrentAccount(account: nil)
            })
            
        }
    }
}

