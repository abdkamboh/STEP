//
//  GetDialogModel.swift
//  STEP
//
//  Created by Farhan Yousaf on 22/02/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation
struct GetDialogModelElement: Codable {
    let dialogID, programID, header, getDialogModelDescription: String?
    let link: String?
    let batch, isRecursive: Int?

    enum CodingKeys: String, CodingKey {
        case dialogID = "dialogId"
        case programID = "programId"
        case header
        case getDialogModelDescription = "description"
        case link, batch, isRecursive
    }
}

typealias GetDialogModel = [GetDialogModelElement]?
