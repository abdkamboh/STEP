//
//  VocabularyModel.swift
//  STEP
//
//  Created by apple on 09/06/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct VocabularyModel: Codable {
    let vocabularyID, programID, word, link: String?
    let status, orderNo: Int?

    enum CodingKeys: String, CodingKey {
        case vocabularyID = "vocabularyId"
        case programID = "programId"
        case word, link, status, orderNo
    }
}
