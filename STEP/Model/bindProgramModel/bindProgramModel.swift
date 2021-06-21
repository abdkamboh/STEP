//
//  bindProgramModel.swift
//  STEP
//
//  Created by Farhan Yousaf on 22/02/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

struct BindProgramModelElement: Codable {
    let studentProgramID, providedProgram, fullName, imageLink: String?

    enum CodingKeys: String, CodingKey {
        case studentProgramID = "studentProgramId"
        case providedProgram, fullName, imageLink
    }
}
typealias BindProgramModel = [BindProgramModelElement]?
