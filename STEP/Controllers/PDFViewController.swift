//
//  PDFViewController.swift
//  STEP
//
//  Created by apple on 20/06/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import PDFKit
class PDFViewController: UIViewController {

    @IBOutlet weak var pdfView: PDFView!
    var path : String?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        DispatchQueue.main.async {
                       CustomLoader.instance.hideLoaderView()
                   }
        if let pdfDocument = PDFDocument(url: URL(fileURLWithPath: path!)) {
                self.pdfView.document = pdfDocument
            self.pdfView.backgroundColor = .white
                          self.pdfView.autoScales = true
                         // self.pdfView.maxScaleFactor = 0.5
                          self.pdfView.minScaleFactor = self.pdfView.scaleFactorForSizeToFit
                          self.pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                           //pdfView.autoScales = true
                          // pdfView.displayDirection = .vertical
                       
        }
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
           if #available(iOS 13.0, *) {
               return .darkContent
           } else {
               return .default
           }
       }
    @IBAction func backPressed(_ sender : UIButton){
        self.dismiss(animated: true, completion: nil)
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

}
