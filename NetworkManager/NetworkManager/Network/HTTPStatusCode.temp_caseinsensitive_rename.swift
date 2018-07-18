//
//  HttpStatusCode.swift
//  NetworkManager
//
//  Created by Den Jo on 15/07/2018.
//  Copyright © 2018 Den Jo. All rights reserved.
//

import Foundation

enum HTTPStatusCode: Int {
    case ok                  = 200
    case created             = 201
    case accepted            = 202
    case unauthorized        = 401
    case unprocessableEntity = 422
}

