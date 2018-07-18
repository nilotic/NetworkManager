//
//  HTTPHeaderValue.swift
//  NetworkManager
//
//  Created by Den Jo on 15/07/2018.
//  Copyright © 2018 Den Jo. All rights reserved.
//

import Foundation

enum HTTPHeaderValue: String {
    case applicationJSON     = "application/json"
    case urlEncoded          = "application/x-www-form-urlencoded"
    case utf8                = "charset=utf-8"
    case utf8Endcoded        = "application/x-www-form-urlencoded;charset=utf-8"
    case applicationJsonUTF8 = "application/json;charset=utf-8"
    case multipart           = "multipart/form-data; boundary=f7b13d9b-92b7-4129-932a-5fa7983cca42" // The boundary is an UUID that is randomly generated
}
