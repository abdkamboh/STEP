//
//  WorkSheet.swift
//  STEP
//
//  Created by apple on 21/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct WorkSheetModel: Codable {
    let id, courseID, type, title: String?
    let status: Int?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case courseID = "CourseId"
        case type = "Type"
        case title = "Title"
        case status = "Status"
    }
}


struct  WorkSheetElementModel: Codable {
    let workSheetID, workDayID, courseID, keyFile: String?
    let mcqs: String?
    let status: Int?
    let title: String?
    let orderNo: Int?
    let keyFileEx: String?
    let duration:Int?

    enum CodingKeys: String, CodingKey {
        case workSheetID = "workSheetId"
        case workDayID = "workDayId"
        case courseID = "courseId"
        case keyFile, mcqs, status, title, orderNo, keyFileEx, duration
    }
}
