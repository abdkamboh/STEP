//
//  ProgramModel.swift
//  STEP
//
//  Created by apple on 19/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

// MARK: - ProgramModleElement
struct ProgramModleElement: Codable {
    let workDayID, dated: String?
    let fullName, workSheet, video: String?
    let isEnable: Int?
    let workType: String?

    enum CodingKeys: String, CodingKey {
        case workDayID = "workDayId"
        case dated, fullName, workSheet, video, isEnable, workType
    }
    
    func getInnerValues()-> [String]{
        var values = [String]()
        if let video = (self.video?.split(separator: ",") ){
                   for v in video{
                       values.append("\(v)")
                   }
               }
        if let worksheet = (self.workSheet?.split(separator: ",") ){
            for v in worksheet{
                values.append("\(v)")
            }
        }
        return values
    }
    
    func getInnerValuesCount()-> Int{
        var values = [String]()
        if let video = (self.video?.split(separator: ",") ){
                   for v in video{
                       values.append("\(v)")
                   }
               }
        if let worksheet = (self.workSheet?.split(separator: ",") ){
            for v in worksheet{
                values.append("\(v)")
            }
        }
        return values.count
    }
}

typealias ProgramModle = [ProgramModleElement]

class WeekClass {
    var week = -1
    var year = -1
    init(_ w:Int,_ y:Int) {
        week = w
        year =  y
    }
}


class ImageName {
   static let test = "ic_dbtest"
   static let lecture = "ic_dbvideo"
   static let discussion = "ic_dbdiscussion"
   static let workSheet = "ic_dbworksheet"
   static let untest = "ic_dbtestw"
   static let unlecture = "ic_dbvideow"
   static let undiscussion = "ic_dbdiscussionw"
   static let unworkSheet = "ic_dbworksheetw"
    
}

class DropDownModel {
    var id = Int()
    var ProgramId = String()
    var firstName = String()
    var lastName = String()
    init(_ id : Int,_ pid : String,_ fname: String,_ lname : String) {
        self.id = id
        ProgramId = pid
        firstName = fname
        lastName = lname
    }
}
