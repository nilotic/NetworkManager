//
//  UserDataMutation.swift
//  NetworkManager
//
//  Created by den on 18/07/2018.
//  Copyright © 2018 Den Jo. All rights reserved.
//

import Foundation

struct UserDataMutation {
    let user: User
    let fields: [UserField] /// Response fields
}

extension UserDataMutation: Encodable {
    
    enum Key: String, CodingKey {
        case query
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        let query = fields.reduce("") { $0 + "\($0 != "" ? " ": "")" + $1.rawValue }
        let arguments = "upsertUser(sub:\"\(user.sub)\",email:\"\(user.email)\",phone_user:\"\(user.phoneNumber)\",name:\"\(user.name)\",ageGroup:\(user.ageGroup),gender:\"\(user.gender)\")"
        
        try container.encode("mutation{\(arguments){\(query)}}", forKey: .query)
    }
}


