//
//  User.swift
//  NetworkManager
//
//  Created by den on 17/07/2018.
//  Copyright © 2018 Den Jo. All rights reserved.
//

import Foundation

struct User: Decodable {
    var id: String
    let sub: String
    var name: String
    var email: String
    var phoneNumber: String
    var createdDate: Date?
    var ageGroup: UInt
    var gender: String
}

extension User {
    
    private enum Key: String, CodingKey {
        case id = "_id"
        case sub
        case name
        case createdDate
        case email
        case phone_user
        case ageGroup
        case gender
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Key.self)
        
        do {
            id          = try values.decode(String.self, forKey: .id)
            name        = try values.decode(String.self, forKey: .name)
            email       = try values.decode(String.self, forKey: .email)
            phoneNumber = try values.decode(String.self, forKey: .phone_user)
            sub         = try values.decode(String.self, forKey: .sub)
            ageGroup    = try values.decode(UInt.self,   forKey: .ageGroup)
            gender      = try values.decode(String.self, forKey: .gender)
            
        } catch { throw DecodingError.keyNotFound(Key.id, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get the userInfo.")) }
      
        do {
            var string = try values.decode(String.self, forKey: .createdDate)
            
            let formatter = ISO8601DateFormatter()
            if #available(iOS 11.0, *) {
                formatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withFractionalSeconds, .withTimeZone]
                
            } else {
                string = string.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
            }
            
            createdDate = formatter.date(from: string)
        } catch {}
    }
}
