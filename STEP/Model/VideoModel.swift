//
//  VideoModel.swift
//  STEP
//
//  Created by apple on 21/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct VideoModel: Codable {
    let id, courseID, type, title: String?
    let description, videoLink: String?
    let status: Int?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case courseID = "CourseId"
        case type = "Type"
        case title = "Title"
        case description = "Description"
        case videoLink = "VideoLink"
        case status = "Status"
    }
}
