////
////  CustomLoader.swift
////  STEP
////
////  Created by apple on 19/05/2020.
////  Copyright © 2020 apple. All rights reserved.
////
//
import Foundation
import UIKit
import Lottie

class CustomLoader: UIView {
     static let instance = CustomLoader()

       var viewColor: UIColor = .black
       var setAlpha: CGFloat = 0.4

       let newView = AnimationView(name: "wave")


       lazy var transparentView: UIView = {
           let transparentView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
           transparentView.backgroundColor = viewColor.withAlphaComponent(setAlpha)
        transparentView.backgroundColor = .clear

        transparentView.isUserInteractionEnabled = true
           return transparentView
       }()

       func showLoaderView() {

        DispatchQueue.main.async {

            self.newView.frame = CGRect(x: UIScreen.main.bounds.width/2 - 50 , y: UIScreen.main.bounds.height/2 - 50, width: 120, height: 120)
            self.newView.loopMode = LottieLoopMode.loop
            self.addSubview(self.newView)
            self.transparentView.addSubview(self.newView)
            self.newView.play()
            self.transparentView.bringSubviewToFront(self.newView)
            if #available(iOS 13.0, *) {
                let keyWindow1 = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
                keyWindow1?.addSubview(self.transparentView)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.keyWindow?.addSubview(self.transparentView)

            }
           
        }
       }

       func hideLoaderView() {
        DispatchQueue.main.async {
            self.newView.stop()
           self.transparentView.removeFromSuperview()
        }
       }

}
