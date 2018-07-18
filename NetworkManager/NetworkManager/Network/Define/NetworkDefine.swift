//
//  NetworkDefine.swift
//  NetworkManager
//
//  Created by Den Jo on 15/07/2018.
//  Copyright © 2018 Den Jo. All rights reserved.
//

import Foundation
import UIKit

let host = URL(string: "https://")!


extension URLRequest {
    
    init(httpMethod: HTTPMethod, url: URL) {
        self.init(url: url)
        
        // Set request
        self.httpMethod = httpMethod.rawValue
        timeoutInterval = 90.0
    
        setValue(authorization,                                                              forHTTPHeaderField: "Authorization")
        setValue(Bundle.main.bundleIdentifier ?? "",                                         forHTTPHeaderField: "bundleIdentifier")
        setValue(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "", forHTTPHeaderField: "appVersion")
        setValue(UIDevice.current.systemVersion,                                             forHTTPHeaderField: "iOS")
        setValue(UIDevice.current.model,                                                     forHTTPHeaderField: "deviceModel")
        
        /*
        #if APP_EXTENSION
        // Set access token
        if let currentAuthorizationInfo = UserDefaults(suiteName: UserDefaultsGroupKey.GroupName)?.object(forKey: UserDefaultsGroupKey.AuthorizationInfo) as? [String:Any],
            let currentTokenType = currentAuthorizationInfo[UserDefaultsGroupKey.TokenType] as? String, let currentAccessToken = currentAuthorizationInfo[UserDefaultsGroupKey.AccessToken] as? String {
            setValue("\(currentTokenType) \(currentAccessToken)", forHTTPHeaderField: HTTPHeaderKey.authorization)
        }
        
        #else
        // Set access token
        if let accessToken = AccessTokenManager.shared.accessToken {
            let accessTokenString =  "\(accessToken.type) \(accessToken.token)"
            setValue(accessTokenString, forHTTPHeaderField: HTTPHeaderKey.authorization)
        }
        
        // GoogleAnalytics Client ID
        if let googleAnalyticsID = GAI.sharedInstance().defaultTracker?.get(kGAIClientId) {
            setValue(googleAnalyticsID, forHTTPHeaderField: HTTPHeaderKey.googleAnalyticsID)
        }
        #endif
        */
    }
    
    mutating func addValue(value: HTTPHeaderValue, field: HTTPHeaderField) {
        addValue(value.rawValue, forHTTPHeaderField: field.rawValue)
    }
}
