//
//  File.swift
//  STEP
//
//  Created by apple on 09/06/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation


struct ResourceModelElement: Codable {
    let resourceID, programID: String?
    let activityType: String?
    let linked: String?
    let status, batch: Int?
    var fullName: String?
    let courseID: String?

    enum CodingKeys: String, CodingKey {
        case resourceID = "resourceId"
        case programID = "programId"
        case activityType, linked, status, batch, fullName
        case courseID = "courseId"
    }
}




typealias ResourceModel = [ResourceModelElement]

