//
//  McqsModel.swift
//  STEP
//
//  Created by apple on 28/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct Mcq: Codable {
    let answers: [Answer]?
    let isEnable: Int?
    let questionText: String?
}

// MARK: - Answer
struct Answer: Codable {
    let isEnable: Int?
    let isCorrect: Bool?
    let answerText, correctAnswer: String?
}
