//
//  LoginModel.swift
//  STEP
//
//  Created by apple on 10/06/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct LoginModel: Codable {
    let userID, roleID, userName, password: String?
    var varification: String?
    let isEnable, batch: Int?
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case roleID = "roleId"
        case userName, password, varification, isEnable, batch
    }
}
