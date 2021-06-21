//
//  SplashViewController.swift
//  STEP
//
//  Created by apple on 18/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet weak var wheelImage : UIImageView!
    @IBOutlet weak var popUpView:customView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.popUpView.isHidden = true


    }
 
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()

        VersionCheck.shared.checkForUpdate { isUpdated,currentVersion,appStoreVersion in

                    

                    if isUpdated{

                        DispatchQueue.main.async {

                            

                            self.popUpView.isHidden = false

                            self.popUpView.message.text = "Your current Application version is: \(currentVersion) and latest updated version is: \(appStoreVersion) Please update your Application."

                        }

                    }

                    else

                  {
                    DispatchQueue.main.async { [self] in
                        if checkUser(){
                            perform(#selector(gotoDashboard), with: nil, afterDelay: 3)
                        }else{
                            perform(#selector(gotoLogin), with: nil, afterDelay: 3)
                        }                    }
                  }
        }
        wheelImage.startRotateBy(angle: -(Double.pi/2))

    }
    
    @objc func gotoLogin (){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func checkUser()->Bool{
        if getUserData() != nil{
         return true
        }
        return false
    }
    override var prefersStatusBarHidden: Bool {
        return true
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



class VersionCheck {

    

    public static let shared = VersionCheck()

    

    func checkForUpdate(completion:@escaping(Bool, _ currentVersion:String, _ apstoreVersion:String)->()){

        

        guard let bundleInfo = Bundle.main.infoDictionary,

            let currentVersion = bundleInfo["CFBundleShortVersionString"] as? String,

            let identifier = bundleInfo["CFBundleIdentifier"] as? String,

            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)")

            else{

                completion(false,"","")

                return

        }

        

        let task = URLSession.shared.dataTask(with: url) {

            (data, resopnse, error) in

            if error != nil{

                completion(false,"","")

            }else{

                do{

                    guard let reponseJson = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any],

                        let result = (reponseJson["results"] as? [Any])?.first as? [String: Any],

                        let version = result["version"] as? String

                        else{

                            completion(false,"","")

                            return

                    }

                    if currentVersion < version{

                        completion(true,currentVersion,version)

                    }else{

                        completion(false,"","")

                    }

                }

                catch{

                    completion(false,"","")

                }

            }

        }

        task.resume()

    }

}

