//
//  DetailListModel.swift
//  STEP
//
//  Created by apple on 21/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct DetailListModel: Codable {
    let workDayID, fullName, dated, workSheet: String?
    let video: String?
    let isEnable: Int?
    let workType: String?

    enum CodingKeys: String, CodingKey {
        case workDayID = "workDayId"
        case fullName, dated, workSheet, video, isEnable, workType
    }
}
