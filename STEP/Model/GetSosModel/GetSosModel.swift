//
//  GetSosModel.swift
//  STEP
//
//  Created by Farhan Yousaf on 22/02/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation
struct GetSosModelElement: Codable {
    let sosID, programID: String?
    let batch: Int?
    let link: String?
    let statusID: Int?

    enum CodingKeys: String, CodingKey {
        case sosID = "sosId"
        case programID = "programId"
        case batch, link
        case statusID = "statusId"
    }
}
typealias GetSosModel = [GetSosModelElement]?
