//
//  Extension.swift
//  STEP
//
//  Created by apple on 18/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import UIKit
import DropDown
import MSAL
extension UIView{
  
    func clearBackgrounds() {
          self.backgroundColor = UIColor.clear
          for subview in self.subviews {
              subview.clearBackgrounds()
          }
      }
    func startRotateBy(angle:Double) {
      DispatchQueue.main.async {
          UIView.animate(withDuration: 15, animations: {
              self.transform = self.transform.rotated(by: CGFloat(angle))
              //      self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
              //      self.transform = CGAffineTransform(rotationAngle: 0)
          }) { (isCompleted) in
              DispatchQueue.main.async {
                  self.startRotateBy(angle: angle)
              }
          }
      }
      
    }
}

extension UIViewController{
   func getOPtionTag(option:String)-> Int{
       if option == "A"{
           return 0
       }else if option == "B"{
           return 1
       }else if option == "C"{
           return 2
       }else if option == "D"{
           return 3
       }
       return -1
   }
    func rotateImage(image: UIImageView, angle:CGFloat) {
        UIView.animate(withDuration: 0.3, animations: {
            image.transform = CGAffineTransform(rotationAngle: (angle * .pi) / 180.0 )
        })
    }
    func rotateImage1(image: UIImageView, angle:CGFloat) {
              UIView.animate(withDuration: 0.6, animations: {
                  image.transform = CGAffineTransform(rotationAngle: (angle * .pi) / 180.0 )
               
              })
          }
   @objc func gotoDashboard(){
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let vc = storyboard.instantiateViewController(withIdentifier: "DashBoardViewController") as! DashBoardViewController
          self.navigationController?.pushViewController(vc, animated: true)
      }
 @IBAction func gotoSlate(){
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let vc = storyboard.instantiateViewController(withIdentifier: "SlateViewController") as! SlateViewController
             self.navigationController?.pushViewController(vc, animated: true)
         }
    func saveUserData(value:LoginModel?)

    {

        let encoder = JSONEncoder()
        let defaults = UserDefaults.standard
        if let encoded = try? encoder.encode(value) {

            defaults.set(encoded, forKey: "SavedPerson")
        }else{
            defaults.set(nil, forKey: "SavedPerson")
        }

    }

    

    func getUserData()->LoginModel?
    {
        var value:LoginModel?
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LoginModel.self, from: savedPerson) {
                value = loadedPerson
            }
        }
        return value
    }

    func ShareAction(sender: UIButton) {
//      let shareText = "STEP by PGC Result \nWrong Answer  \nUnattempted Question :: "
//
//      let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
//      if vc.popoverPresentationController != nil {
//        vc.popoverPresentationController? .sourceView = self.view
//        vc.popoverPresentationController? .sourceRect = CGRect(x:sender.bounds.midX, y: sender.bounds.midY,width: 315,height: 230)
//        present(vc, animated: true)
//      }else{
//        present(vc, animated: true)
//      }
        let items = ["Step by PGC", "https://itunes.apple.com/us/app/step-by-pgc/id1259751445?ls=1&mt=8"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
      
    }
    
    func rateUS(id:String){
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(id)?mt=8&action=write-review"){
            UIApplication.shared.open(url)

        }
    }
    func gotoHome(){
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: DashBoardViewController .self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    func logout(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LogoutViewController") as! LogoutViewController
        if let nav = self.navigationController{
        vc.navigation = nav 
        }
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    func makeRightSideMenu(sender:UIButton){
             let dropDown = DropDown()
            dropDown.anchorView = sender
        dropDown.width = 150
        
            // By default, the dropdown will have its origin on the top left corner of its anchor view
            // So it will come over the anchor view and hide it completely
            // If you want to have the dropdown underneath your anchor view, you can do this:
            dropDown.bottomOffset = CGPoint(x: 0, y: 0)
            dropDown.backgroundColor = .white
            dropDown.selectedTextColor = #colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.5019607843, alpha: 1)
            dropDown.selectionBackgroundColor = .clear
            dropDown.textColor = #colorLiteral(red: 0.5607843137, green: 0.5921568627, blue: 0.6392156863, alpha: 1)
            // You can also use localizationKeysDataSource instead. Check the docs.
        let values = ["Home","Share","Rate us","Logout"]
            dropDown.dataSource = values
        dropDown.show()
            //dropDown.selectRows(at: [0])
            // Action triggered on selection
            dropDown.selectionAction = { [] (index, item) in
                if index == 0{
                    self.gotoHome()
                }else if index == 1{
                    self.ShareAction(sender: sender)
                }else if index == 2{
                    self.rateUS(id: "1259751445")
                }else{
                    self.logout()
                }
            }
            dropDown.cancelAction = {

            }
    }
    func isInternetConnected()->Bool
    {
        if Reachability.isConnectedToNetwork()
        {
            return true
        }
        else
        {
            self.POPUp(message: "No internet connection", time: 1.8)
            return false
        }
    }

    func DateConvert(_ date:String)->String{
        let dateFormatter = DateFormatter()
        
        if let result =  getDateFromString(dateString: date){
            dateFormatter.dateFormat = "dd MMM yyyy"
            return dateFormatter.string(from: (result))
        }
        return ""
    }
    func getDayName(_ date:String)->String{
        let dateFormatter = DateFormatter()
        
        if let result =  getDateFromString(dateString: date){
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: (result))
        }
        return ""
    }
    func getDateFromString(dateString:String)-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let result =  dateFormatter.date(from: dateString){
            return result
        }
        return nil
    }
    func hideNavigationBar(){
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }

    
    func showNavigationBar() {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    func POPUp(message:String, time:Float)
    {
        
        //            if let bgView = self.view.viewWithTag(88) {
        //                bgView.removeFromSuperview()
        //            }
        
        if let msgView = self.view.viewWithTag(89) {
            msgView.removeFromSuperview()
        }
        
        if let lbl = self.view.viewWithTag(90) {
            lbl.removeFromSuperview()
        }
        
        
        
        
        let sideDIfference:CGFloat = 40.0
        let heightValue : CGFloat = 55.0
        let screenSize: CGRect = UIScreen.main.bounds
        let bottomDifference:CGFloat = 50
        let height:CGFloat = screenSize.height - (heightValue + bottomDifference)
        
        //Mark BG
        
        //        let myBgView = UIView(frame: CGRect(x:0, y:0, width:screenSize.width, height: screenSize.height))
        //        myBgView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        //        myBgView.tag = 88
        //        self.view.addSubview(myBgView)
        //        self.view.bringSubviewToFront(myBgView)
        
        //Mark: View
        
        let myView = UIView(frame: CGRect(x:sideDIfference, y:height, width: (screenSize.width - (sideDIfference * 2)), height: heightValue))
        myView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        myView.tag = 89
        self.view.addSubview(myView)
        self.view.bringSubviewToFront(myView)
        myView.layer.cornerRadius = 20
        
        //Mark:Lable
        
        let myLable = UILabel(frame: CGRect(x:(sideDIfference + 5), y:height, width: (screenSize.width - ((sideDIfference * 2) + 5)), height: heightValue))
        myLable.text = message
        myLable.textColor = UIColor.white.withAlphaComponent(1.0)
        myLable.textAlignment = .center
        myLable.tag = 90
        myLable.numberOfLines = 2
        self.view.addSubview(myLable)
        self.view.bringSubviewToFront(myLable)
        
        UIView.animate(withDuration: TimeInterval(time), animations: {
            
            myView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
            myLable.textColor = UIColor.white.withAlphaComponent(1.0)
            //   myBgView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            
            
        }, completion: {
            finished in
            
            
            UIView.animate(withDuration: TimeInterval(time), animations: {
                
                //                myView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                //                myLable.textColor = UIColor.white.withAlphaComponent(0.0)
                //                myBgView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                
                
            }, completion: {
                finished in
                
                myView.removeFromSuperview()
                myLable.removeFromSuperview()
                //      myBgView.removeFromSuperview()
                
                
            })
        })
        
        
        
    }
    func getDAyValue(day:String)->String{
        let array = day.split(separator: "-")
        if array.count > 0{
            
            if array[1].count == 1{
                return "\(array[0]) 0\(array[1])"
            }else{
                return "\(array[0]) \(array[1])"
            }
        }
        return ""
    }
    func postManagerUser(method: String, isThisURLEmbdedData: Bool, urlString: String,timeoutInterval:Int = 10 ,parameter : [String: Any] , success:@escaping (_ response:Data)->(), failure:@escaping (_ error:Error)->())
        
    {
        let parameters = parameter
        print("param: ",parameters)
        let value = urlString.replacingOccurrences(of: " ", with: "")
        guard let url = URL(string: value)
            else{
                return
        }
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Content-Type" : "application/json"
        ]
        let session = URLSession(configuration: config)
        var request = URLRequest(url: url)
        request.httpMethod = method
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        session.dataTask(with: request, completionHandler:{(data, response, error)
            in
            DispatchQueue.main.async {
                CustomLoader.instance.hideLoaderView()
            }
            if let response = response
            {
                print("Response: ",response)
            }
            if let error = error
            {
                DispatchQueue.main.async {
                    print(error)
                    failure(error)
                }
            }
            if let data = data
            {
                success(data)
            }
        }).resume()
    }
}




extension UIView {
    class func fromNib<T: UIView>() -> T {
           return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
       }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
//            layer.shadowOpacity = 0.4
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
            
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
}

extension UIButton{
    private func actionHandler(action:(() -> Void)? = nil) {
         struct __ { static var action :(() -> Void)? }
         if action != nil { __.action = action }
         else { __.action?() }
     }
     @objc private func triggerActionHandler() {
         self.actionHandler()
     }
    func actionHandler(controlEvents control :UIControl.Event, ForAction action:@escaping () -> Void) {
         self.actionHandler(action: action)
         self.addTarget(self, action: #selector(triggerActionHandler), for: control)
     }
}
//Splash Color Scheme
//Bottom Blue Color #252980
//Step into Bright Future Color
//blue #252980
//red #9e151d
//
//Login Color Scheme
//Bottom Red Color #9e151d
//Step into Bright Future Color
//blue #252980
//red #9e151d
//Login botton color #0078d4
//Login text color #ffffff
//
//Dashboard Color Scheme
//Header text color #252980
//Session Background color #eaecf3 (ECAT/LECAT (FSc))
//Session Text color #252980
//
//Week Selected blue color #252980
//Week Un Selected blue color #9ea1aa
//Week background strip color #ffffff
//Full App Blue Color Text #252980
//Monday Botton border Green color #92e29f
//Test marks total text color #fa6b8c
//Test marks total background color #eaeaea
//Start Button background color #e4e5ff
//Start Text Color #252980
//
//Disable Start Button background color #f3f7ff
//Disable Start Text Color #8f97a3
//Icon background color #f3f7ff
//Icon Text color #252980
//Disable Icon Text color #8f97a3
//
//card background color #ffffff
//Card border color #eaecf3
//Tuesday/date/days Text color #8f97a3
//Tuesday Bottom border red color #fc476
