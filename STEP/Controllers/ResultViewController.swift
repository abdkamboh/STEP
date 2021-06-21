//
//  ResultViewController.swift
//  STEP
//
//  Created by apple on 01/06/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Charts
class ChartDara{
    var key = ""
    var value = Double()
    init(_ k:String,_ v:Double) {
        key = k
        value = v
    }
}
class ResultViewController: UIViewController {
    var day = ""
    var date = ""
    var cheight = CGFloat(90)
    var cellheight = CGFloat(60)
    var selecteledSubject = 0
    //    var chartView: PieChart!
    //    var subjectChartView: PieChart!
    //  @IBOutlet var chartView: PieChart!
    @IBOutlet weak var pieChartView:PieChartView!
    
    @IBOutlet weak var SubjectPieChartView:PieChartView!
    // @IBOutlet weak var viewB:UIView!
    
    @IBOutlet weak var dayName : UILabel!
    @IBOutlet weak var CorrectMarks: UILabel!
    @IBOutlet weak var inCorrectMarks: UILabel!
    @IBOutlet weak var totalObtainMarks: UILabel!
    @IBOutlet weak var allTotalMarks: UILabel!
    @IBOutlet weak var totalMarks : UILabel!
    @IBOutlet weak var obtianMarks : UILabel!
    @IBOutlet weak var correctQuestion : UILabel!
    @IBOutlet weak var inCorrectQuestion : UILabel!
    @IBOutlet weak var unAttemptedQuestion : UILabel!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var subjectName : UILabel!
    @IBOutlet weak var dateDay : UILabel!
    @IBOutlet weak var lineView : UIView!
    @IBOutlet weak var totalLabel : UILabel!

    //   @IBOutlet var subjectChartView: PieChart!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var testData : [WorkSheetElementModel]?
    var SubjectData : [WorkSheetModel]?
    var AnswerArray = [[AnswerSelected]]()
    var mcqsList = [[Mcq]]()
    var colorList = [UIColor]()
    // dataType
    var chartData = [ChartDara]()
    var user: LoginModel!
    var userType = ""
    var marksMul:Double = 0
    override func viewDidLoad() {
        user = getUserData()
        userType = getTestType(head: headType)
        if headType.uppercased().contains("MDCAT"){
            marksMul = 1
            CorrectMarks.text = "Every Correct Answer Gives 1 Marks."
            inCorrectMarks.text = "Every Wrong Answer Deducts No Marks."
        }else{
            marksMul = 4
            CorrectMarks.text = "Every Correct Answer Gives 4 Marks."
            inCorrectMarks.text = "Every Wrong Answer Deducts 1 Marks."


        }

        super.viewDidLoad()
        
        dayName.text = day
        dateDay.text = date
        
        //  deviceCheck()
        chartData = [ChartDara("Physics", 20),ChartDara("Chemistry", 30),ChartDara("Math", 90),ChartDara("English", 50)]
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionViewHeight.constant = cheight
        DrawSubjectChartOne()
        if let item = SubjectData?[0]{
            subjectName.text = item.courseID
            subjectName.textColor = getColor(subject: item.courseID ?? "")
            obtianMarks.textColor = getColor(subject: item.courseID ?? "")
            DrawSubjectChartTwo()
        }
        DispatchQueue.main.async {
            self.getCountTotalQuestion()
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
    func chartData1(){
        pieChartView.clear()
        var data = [PieChartDataEntry]()
        for obj in chartData{
            let entry = PieChartDataEntry(value: obj.value, label: obj.key)
            data.append(entry)
        }
        let chart = PieChartDataSet(entries: data, label: "")
        chart.sliceSpace = 2
        chart.selectionShift = 0
        chart.xValuePosition = .outsideSlice
        chart.yValuePosition = .outsideSlice
        chart.valueTextColor = #colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.5019607843, alpha: 1)
        chart.valueLinePart1Length = 0.5
        chart.valueLineColor = #colorLiteral(red: 0.1450980392, green: 0.1607843137, blue: 0.5019607843, alpha: 1)
        chart.drawValuesEnabled = true
        let formatter = NumberFormatter()
               formatter.numberStyle = .percent
               formatter.maximumFractionDigits = 2
               formatter.multiplier = 1.0
               formatter.percentSymbol = "%"
        DispatchQueue.main.async {
            chart.colors = self.colorList
             let chartData = PieChartData(dataSet: chart)
                   self.pieChartView.legend.enabled = false
                   // pieChartView.rotationEnabled = false
                   self.pieChartView.rotationAngle = 270
                   self.pieChartView.setExtraOffsets(left: 0, top: 12, right: 0, bottom: 12)
                   self.pieChartView.holeRadiusPercent = 0.4
                   self.pieChartView.transparentCircleRadiusPercent = 0.5
                   self.pieChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
                   chartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
                   self.pieChartView.data = chartData
        }
    }
    func chartData2(correct:Double,incorrect:Double,notAttempt:Double){
        let array:[Double] = [correct,incorrect,notAttempt]
        var data = [PieChartDataEntry]()
        for obj in array{
            let entry = PieChartDataEntry(value: obj, label: "")
            data.append(entry)
        }
        let chart = PieChartDataSet(entries: data, label: "")
        chart.colors = [#colorLiteral(red: 0.9889493585, green: 0.7062146068, blue: 0.3130962253, alpha: 1),#colorLiteral(red: 0.9450980392, green: 0.2862745098, blue: 0.4352941176, alpha: 1),#colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)]
        chart.selectionShift = 0
        chart.valueTextColor = .clear
        chart.drawValuesEnabled = false
        let chartData = PieChartData(dataSet: chart)
        SubjectPieChartView.legend.enabled = false
        SubjectPieChartView.rotationAngle = 270
        if Device.IS_IPHONE_5{
            
            SubjectPieChartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
            

        }else
        if Device.IS_IPHONE_6{
                   SubjectPieChartView.setExtraOffsets(left: 10, top: 10, right: 10, bottom: 10)

        }else{
            SubjectPieChartView.setExtraOffsets(left: 20, top: 20, right: 20, bottom: 20)
        }
        SubjectPieChartView.rotationEnabled = false
        SubjectPieChartView.holeRadiusPercent = 0.5
        SubjectPieChartView.transparentCircleRadiusPercent = 0.0
        SubjectPieChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        SubjectPieChartView.data = chartData
    }
    
    func deviceCheck(){
        if Device.IS_IPHONE_5 ||  Device.IS_IPHONE_6{
            cheight = 70
            cellheight = 40
        }
    }
    @IBAction func sideMenu(sender:UIButton){
        makeRightSideMenu(sender: sender)
    }
    @IBAction func backPressed(_ sender : UIButton){
        gotoHome()
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

extension ResultViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SubjectData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestSubjectCell", for: indexPath) as! TestSubjectCell
        if let item =  SubjectData?[indexPath.item]{
            cell.subjectImage.image = UIImage(named: "\(item.courseID ?? "")Enable")
            cell.circleView.borderColor = getColor(subject: item.courseID ?? "")
            cell.height.constant = cellheight
            cell.circleView.cornerRadius = cellheight/2
            if indexPath.item == selecteledSubject{
                cell.line.backgroundColor =  getColor(subject: item.courseID ?? "")
            }else{
                cell.line.backgroundColor =  .clear
            }
            cell.subject.text = item.courseID ?? ""
            return cell
        }
        return UICollectionViewCell()
    }
    func getColor(subject:String)->UIColor{
        if subject == "Chemistry" || subject == "Computer Science"{
            return #colorLiteral(red: 0.9594212174, green: 0.5037184954, blue: 0.192730844, alpha: 1)
        }else if subject == "Physics"{
            return #colorLiteral(red: 0.9889493585, green: 0.7062146068, blue: 0.3130962253, alpha: 1)
        }else if subject == "Mathematics" || subject == "Biology"  || subject == "G. Mathematics"{
            return #colorLiteral(red: 0.3021526039, green: 0.4153817296, blue: 0.7058065534, alpha: 1)
        }else if subject == "English"{
            return #colorLiteral(red: 0.5087519884, green: 0.785035789, blue: 0.5360324383, alpha: 1)
        }
        return #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item =  SubjectData?[indexPath.item]{
            selecteledSubject = indexPath.item
            DrawSubjectChartTwo()
            subjectName.text = item.courseID ?? ""
            subjectName.textColor = getColor(subject: item.courseID ?? "")
            obtianMarks.textColor = getColor(subject: item.courseID ?? "")
            collectionView.reloadData()
        }
    }
    
    
    
    //  self.counter.text = "\(selecteled+1)/\(mcqsData.count)"
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets  {
        
        //Where elements_count is the count of all your items in that
        //Collection view...
        let numberofcell = (SubjectData?.count) ?? 0
        let cellCount = CGFloat(numberofcell)
        //If the cell count is zero, there is no point in calculating anything.
        if cellCount > 0 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            print(flowLayout.minimumInteritemSpacing)
            print(flowLayout.itemSize.width )
            let cellWidth = CGFloat(85) //+ //flowLayout.minimumInteritemSpacing
            //20.00 was just extra spacing I wanted to add to my cell.
            let  totalCellWidth = cellWidth * cellCount
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
            if (totalCellWidth < contentWidth) {
                //If the number of cells that exists take up less room than the
                //collection view width... then there is an actual point to centering them.
                
                //Calculate the right amount of padding to center the cells.
                let padding = (contentWidth - totalCellWidth) / 2.0
                print(padding)
                return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
            } else {
                //Pretty much if the number of cells that exist take up
                //more room than the actual collectionView width, there is no
                // point in trying to center them. So we leave the default behavior.
                // return UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
            }
        }
        
        return UIEdgeInsets.zero
    }
    
    func DrawSubjectChartTwo(){
        if let item =  SubjectData?[selecteledSubject]{
            if let index = testData?.firstIndex(where: {$0.courseID == item.courseID}){
                let mcqsData = mcqsList[index]
                let totalQues = Double(mcqsData.count)
                var correct:Double = 0
                var incorrect:Double = 0
                for ans in AnswerArray[selecteledSubject]{
                    if ans.isCheck{
                        correct += 1
                    }else{
                        incorrect += 1
                    }
                }
                let unattempt = totalQues - correct - incorrect
                let obtmarks = (correct*marksMul) - incorrect
                
                SubjectPieChartView.clear()
                correctQuestion.text = "\(Int(correct))"
                inCorrectQuestion.text = "\(Int(incorrect))"
                unAttemptedQuestion.text = "\(Int(unattempt))"
                if obtmarks > 0{
                obtianMarks.text = "\(Int(obtmarks))"
                }else{
                    obtianMarks.text = "0"

                }
                totalMarks.text = "\(Int(totalQues*marksMul))"
                totalLabel.text = "\(Int(totalQues))"
                chartData2(correct: correct, incorrect: incorrect, notAttempt: unattempt)
            }
        }
    }
    
    func DrawSubjectChartOne(){
        if let subdata = SubjectData{
            chartData = []
            colorList = []
            var totalpercentage = Double()
            var i = 0
            for sbjtData in subdata{
                if let index = testData?.firstIndex(where: {$0.courseID == sbjtData.courseID}){
                    let mcqsData = mcqsList[index]
                    let totalQues = Double(mcqsData.count)
                    var correct:Double = 0
                    var incorrect:Double = 0
                    for ans in AnswerArray[i]{
                        if ans.isCheck{
                            correct += 1
                        }else{
                            incorrect += 1
                        }
                    }
                  //  let unattempt = totalQues - correct - incorrect
                    var obtmarks:Double = 0
                    if marksMul == 1 {
                        obtmarks = (correct*marksMul)

                    }else{
                        obtmarks = (correct*marksMul) - incorrect

                    }
                    let percentage = (obtmarks/(totalQues*marksMul))*100
                    if percentage > 0 {
                    chartData.append(ChartDara( "", percentage))
                    
                    colorList.append(getColor(subject: sbjtData.courseID ?? ""))
                    totalpercentage += percentage
                    }
                    
                }
                i += 1
            }
            if totalpercentage < 100 {
                var val = totalpercentage
                if totalpercentage < 0{
                      val = 100 + totalpercentage

                }else{
                      val = 100 - totalpercentage

                }
                
                chartData.append(ChartDara("", val))
                colorList.append(getColor(subject: ""))
            }
            chartData1()
        }
        
    }
    
     func getCountTotalQuestion(){
        var total = 0
        var correct = 0
        var incrrect = 0
         for mcqs in mcqsList{
             total += mcqs.count
         }
        for ansArr in AnswerArray{
            for ans in ansArr{
                if ans.isCheck{
                    correct += 1
                }else{
                    incrrect += 1
                }
            }
        }
        allTotalMarks.text = "\(total*Int(marksMul))"
        if marksMul == 1{
            totalObtainMarks.text = "\(correct)"
        }else{
            let obttotalMarks = (correct*Int(marksMul)) - incrrect
            if obttotalMarks > 0{
                totalObtainMarks.text = "\(obttotalMarks)"
            }else{
                totalObtainMarks.text = "0"
            }
        }
     }
}
