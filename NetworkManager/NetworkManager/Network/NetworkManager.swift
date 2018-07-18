//
//  NetworkManager.swift
//  NetworkManager
//
//  Created by Den Jo on 15/07/2018.
//  Copyright © 2018 Den Jo. All rights reserved.
//

import UIKit
import Foundation

final class NetworkManager: NSObject {
    
    // MARK: - Singleton
    static let shared = NetworkManager()
    private override init() {   // This prevents others from using the default initializer for this calls
        super.init()
    }
    
    
    // MARK: Private
    private let encoder = JSONEncoder()
    
    private var response = { (data: Data?, urlResponse: URLResponse?, error: Error?) -> Response? in
        // Check response status
        guard let urlResponse = urlResponse as? HTTPURLResponse, let statusCode = HTTPStatusCode(rawValue: urlResponse.statusCode), error == nil  else {
            log(.error, "Failed to get responseData. Error Description: \(error.debugDescription)")
            return nil
        }
        
        switch statusCode {
        case .ok, .created, .accepted:
            break
            
        case .unauthorized:
            return nil
            
        default:
            log(.error, """
                Failed to get the responseData.
                HTTP status: \(statusCode.rawValue)
                URL:         \(urlResponse.url?.absoluteString ?? "")
                HeaderFiled: \(urlResponse.allHeaderFields.description))
                """)
            return nil
        }
        
        log(.info, "ResponseData: \n\(String(describing: String(data: data ?? Data(), encoding: .utf8)))\n")
        return Response(data: data, urlResponse: urlResponse)
    }
    
    
    
    
    // MARK: - Function
    // MARK: Public
    func request(urlRequest: URLRequest, delegateQueue queue: OperationQueue? = nil, completion: @escaping (_ data: Response?) -> Void) -> Bool {
        // Request
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: queue)
        urlSession.dataTask(with: urlRequest, completionHandler: { data, urlResponse, error in
            completion(self.response(data, urlResponse, error))
            urlSession.finishTasksAndInvalidate()
        }).resume()
        
        return true
    }
    
    func request<T: Encodable>(urlRequest: URLRequest, requestData: T, delegateQueue queue: OperationQueue? = nil, completion: @escaping (_ requestData: T, _ data: Response?) -> Void) -> Bool {
        var request = urlRequest
        
        guard let httpMethod = HTTPMethod(request: request) else {
            log(.error, "HTTP method is invalid.")
            return false
        }
        
        switch httpMethod {
        case .put, .get :
            guard let urlComponets = urlComponets(from: request.url, data: requestData) else {
                log(.error, "Failed to get a query.")
                return false
            }
            request.url = urlComponets.url  // Insert parameters to the url
            
        case .post:
            if let contentType = request.value(forHTTPHeaderField: HTTPHeaderField.contentType.rawValue) {
                if contentType.range(of: HTTPHeaderValue.urlEncoded.rawValue) != nil {
                    request.httpBody = urlComponets(from: request.url, data: requestData)?.query?.data(using: .utf8, allowLossyConversion: false)        // Insert parameters to the body
                    
                } else if contentType.hasPrefix(HTTPHeaderValue.applicationJSON.rawValue) {
                    do { request.httpBody = try encoder.encode(requestData) } catch { log(.error, error.localizedDescription) }                         // Insert parameters to the body
                }
                
            } else {
                request.httpBody = urlComponets(from: request.url, data: requestData)?.query?.data(using: .utf8)                                         // Insert parameters to the body
            }
        }
        
        // Request
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: queue)
        urlSession.dataTask(with: request, completionHandler: { data, urlResponse, error in
            completion(requestData, self.response(data, urlResponse, error))
            urlSession.finishTasksAndInvalidate()
        }).resume()
        
        return true
    }
    
    
    // MARK: Private
    private func urlComponets<T: Encodable>(from url: URL?, data: T) -> URLComponents? {
        guard let string = url?.absoluteString, var urlComponent = URLComponents(string: string) else { return nil }
        
        do {
            guard var jsonData = try JSONSerialization.jsonObject(with: encoder.encode(data), options: .mutableContainers) as? [String:Any] else { return nil }
            
            // Remove null values
            for key in jsonData.keys.filter({ jsonData[$0] is NSNull }) { jsonData.removeValue(forKey: key) }
            
            var queryItems = [URLQueryItem]()
            for (key, value) in jsonData {
                queryItems.append(URLQueryItem(name: key, value: "\(value)"))
            }
            
            urlComponent.queryItems = queryItems
            return urlComponent
            
        } catch {
            return nil
        }
    }

    private func setSSLPolicies(_ serverTrust: SecTrust) -> Bool {
        // Set SSL policies for domain name check
        let policies = [SecPolicyCreateSSL(true, host.absoluteString as CFString)] as CFTypeRef
        SecTrustSetPolicies(serverTrust, policies)
        return true
    }
    
    private func handleSSL(_ session: Foundation.URLSession, challenge: URLAuthenticationChallenge) -> Bool {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust else {
            log(.error, "Failed to get the authenticationMethod.")
            return false
        }
        
        guard let serverTrust = challenge.protectionSpace.serverTrust, setSSLPolicies(serverTrust) == true else {
            log(.error, "Failed to set trust policies.")
            return false
        }
        
        var secTrustResultType = SecTrustResultType.invalid
        guard SecTrustEvaluate(serverTrust, &secTrustResultType) == errSecSuccess else {
            log(.error, "Failed to check server trust.")
            return false
        }
        
        return true
    }
}


// MARK: - NSURLSession Delegate
extension NetworkManager: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if handleSSL(session, challenge: challenge) == true {
            completionHandler(.useCredential, URLCredential(trust:challenge.protectionSpace.serverTrust!))
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        session.invalidateAndCancel()
    }
}


