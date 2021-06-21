//
//  DetailsListViewController.swift
//  STEP
//
//  Created by apple on 21/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//
import AVFoundation
import UIKit
import AVKit
import MediaPlayer
class DetailsListViewController: UIViewController,AVPlayerViewControllerDelegate {
    var workId = String()
    var type = String() // dataType
    var detailData : DetailListModel?
    var tableData : [VideoModel]?
    
    var moviePlayer = AVPlayerViewController()
    var  playerViewController = AVPlayerViewController()
    var player = AVPlayer()
    
    var clickedIndex = 0
    var lastcheck = 0
    @IBOutlet weak var vedioPlayerViews :UIView!
    @IBOutlet weak var wheelImage : UIImageView!
    @IBOutlet weak var dayName : UILabel!
    @IBOutlet weak var titleNavBar : UILabel!
    @IBOutlet weak var dateDay : UILabel!
    @IBOutlet weak var lineView : UIView!
    @IBOutlet weak var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.moviePlayer.delegate = self
        hideNavigationBar()
        self.titleNavBar.text = type
        callingApi(wid: workId)
        tableView.delegate = self
        tableView.dataSource = self
         wheelImage.startRotateBy(angle: -(Double.pi/2))
        
        // Do any additional setup after loading the view.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            
            try audioSession.setCategory(AVAudioSession.Category.playback)
            
        } catch {
            
            print("Setting category to AVAudioSessionCategoryPlayAndRecord failed.")
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopPlayer()
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
           if #available(iOS 13.0, *) {
               return .darkContent
           } else {
               return .default
           }
       }
    @IBAction func sideMenu(sender:UIButton){
         makeRightSideMenu(sender: sender)
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
    
}
extension DetailsListViewController{
    
    func setLablValues(date :String){
        let day =  getDayName(date)
        let date1 = DateConvert(date)
        self.dayName.text =  day
        if let val = detailData?.fullName{
            self.dateDay.text = "\(date1)-\(getDAyValue(day: val))"
        }else{
            self.dateDay.text = ""
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
                        if let value = jsonObject
                        {
                            if value.count > 0 {
                            self.detailData =  value[0]
                            DispatchQueue.main.async {
                                self.setLablValues(date: self.detailData?.dated ?? "")
                                self.parseData()
                                
                                
                                //self.tableView.reloadData()
                            }
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
    
    
    func parseData(){
        if let jsonObject =  detailData?.video?.data(using: .utf8)!{
            do {
                let data = try JSONDecoder().decode([VideoModel].self, from: jsonObject)
                tableData = []
                for obj in data{
                    if obj.type == self.type{
                        tableData?.append(obj)
                    }
                }
                tableData = tableData?.sorted { $0.courseID! < $1.courseID! }
                self.playVedio()
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}

extension DetailsListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData?.count ?? 0
    }
    @objc func StartButtonPressed(sender:UIButton){
        if lastcheck == sender.tag{
            clickedIndex = lastcheck
            startPlayer()
            
        }else{
            //lastcheck = clickedIndex
            clickedIndex = sender.tag
            stopPlayer()
            playVedio()
           
        }
         tableView.reloadData()
    }
    @objc func StopButtonPressed(sender:UIButton){
        lastcheck = clickedIndex
        clickedIndex = -1
        stopPlayer()
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tableData?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailListCell") as! DetailListCell
        cell.title.text = item?.courseID ?? ""
        cell.subtitle.text = item?.title ?? ""
        cell.stopButton.tag = indexPath.row
        cell.startButton.tag = indexPath.row
        cell.startButton.addTarget(self, action: #selector(StartButtonPressed(sender:)), for: .touchUpInside)
        cell.stopButton.addTarget(self, action: #selector(StopButtonPressed(sender:)), for: .touchUpInside)

        if clickedIndex == indexPath.row{
            cell.stopView.isHidden = false
            cell.startView.isHidden = true
        }else{
            cell.stopView.isHidden = true
            cell.startView.isHidden = false
        }
        cell.lineView.isHidden = false
                 
        
        
        return cell
    }
    
    
}

extension DetailsListViewController {
    
    
    func playerViewController(_: AVPlayerViewController, willBeginFullScreenPresentationWithAnimationCoordinator: UIViewControllerTransitionCoordinator)
    {
        AppUtility.lockOrientation(.all)
    }
    internal func playerViewController(_: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator: UIViewControllerTransitionCoordinator)
    {
        self.navigationController?.navigationBar.isHidden = false
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    func stopPlayer()
    {
        self.player.pause()
    }
    func startPlayer(){
        self.player.play()
    }
    func playVedio()
    {
        if let URLString = tableData?[clickedIndex].videoLink
        {
            if URLString != "" {
                var url = "http:" + URLString + "(format=m3u8-aapl-v4)"
                url = url.replacingOccurrences(of: " ", with: "%20")
                print("url values::: ",url)
                if let b = URL.init(string: url) {
                    let playerItem = AVPlayerItem(url: b)
                    player = AVPlayer(playerItem: playerItem)
                    player.volume = 1.0
                    let playerLayer = AVPlayerLayer(player: player)
                    playerLayer.frame = self.vedioPlayerViews.bounds
                    self.moviePlayer.player = player
                    self.moviePlayer.view.frame = self.vedioPlayerViews.bounds
                    self.vedioPlayerViews.addSubview(self.moviePlayer.view)
                    self.moviePlayer.player?.volume = 1.0
                    self.moviePlayer.showsPlaybackControls = true
                    self.moviePlayer.player!.play()
                }
                
            }
        }
    }
}
