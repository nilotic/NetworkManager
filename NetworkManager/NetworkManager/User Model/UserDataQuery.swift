//
//  UserDataQuery.swift
//  NetworkManager
//
//  Created by den on 18/07/2018.
//  Copyright © 2018 Den Jo. All rights reserved.
//

import Foundation

enum UserField: String, Encodable {
    case id = "_id"
    case order
    case status
    case createdDate
    case modifiedDate
    case sub
    case identityId
    case email
    case phoneNumber = "phone_user"
    case nickName
    case name
    case ageGroup
    case gender
    case userAreas
    case userIssues
    case profileImage
    case skinImages
    case appointments
}

struct UserDataQuery {
    let fields: [UserField]   /// Response fields
}

extension UserDataQuery: Encodable {
    
    enum Key: String, CodingKey {
        case query
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode("{getUser{\(fields.reduce("") { $0 + "\($0 != "" ? " ": "")" + $1.rawValue })}}", forKey: .query)
    }
}
