//
//  HTTPMethod.swift
//  NetworkManager
//
//  Created by Den Jo on 15/07/2018.
//  Copyright © 2018 Den Jo. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case put  = "PUT"
    case post = "POST"
    case get  = "GET"
}

extension HTTPMethod {
    init?(request: URLRequest?) {
        guard let string = request?.httpMethod, let method = HTTPMethod(rawValue: string) else { return nil }
        self = method
    }
}
