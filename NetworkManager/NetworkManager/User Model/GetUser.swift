//
//  GetUser.swift
//  NetworkManager
//
//  Created by den on 17/07/2018.
//  Copyright © 2018 Den Jo. All rights reserved.
//

import Foundation

struct GetUser: Decodable {
    var user: User
}

extension GetUser {
    private enum Key: String, CodingKey {
        case getUser
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Key.self)
        
        do { user = try values.decode(User.self, forKey: .getUser) } catch { throw DecodingError.keyNotFound(Key.getUser, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get the getUser.")) }
    }
}
