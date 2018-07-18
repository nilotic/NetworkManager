//
//  GraphQLResponse.swift
//  NetworkManager
//
//  Created by den on 17/07/2018.
//  Copyright © 2018 Den Jo. All rights reserved.
//

import Foundation

struct GraphQLResponse<T: Decodable> {
    var data: T? = nil
}

extension GraphQLResponse: Decodable {
    
    enum Key: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Key.self)
        do { data = try values.decode(T.self, forKey: .data) } catch { throw DecodingError.keyNotFound(Key.data, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to get graphQL data.")) }
    }
}
