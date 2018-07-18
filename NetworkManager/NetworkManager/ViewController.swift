//
//  ViewController.swift
//  NetworkManager
//
//  Created by Den Jo on 15/07/2018.
//  Copyright © 2018 Den Jo. All rights reserved.
//

import UIKit

let authorization = "eyJraWQiOiJQR0ErZ0tXbUcwaW5nWEhrc0pBbTFQYmJ2ek1tYUlRWmJzRXNaRkJ2Z1FFPSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiJlNmRjNTQ4Mi1jMmExLTQ1MWYtYjAwNy0wMzRhMTY5ZDAxZTMiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImlzcyI6Imh0dHBzOlwvXC9jb2duaXRvLWlkcC5hcC1ub3J0aGVhc3QtMi5hbWF6b25hd3MuY29tXC9hcC1ub3J0aGVhc3QtMl9SSzgxVkhjOWkiLCJwaG9uZV9udW1iZXJfdmVyaWZpZWQiOnRydWUsImNvZ25pdG86dXNlcm5hbWUiOiJlNmRjNTQ4Mi1jMmExLTQ1MWYtYjAwNy0wMzRhMTY5ZDAxZTMiLCJhdWQiOiIycm5kaG45M2QzODZsaTYyazU1cTgwamlhaCIsInRva2VuX3VzZSI6ImlkIiwiYXV0aF90aW1lIjoxNTMxODExNDE0LCJuYW1lIjoi7KGw7YOc7ZiVIiwicGhvbmVfbnVtYmVyIjoiKzgyMTA2MzU0MTY5NiIsImV4cCI6MTUzMTg5OTY0NywiaWF0IjoxNTMxODk2MDQ3LCJlbWFpbCI6ImRlbkBiZWF1dHlwYXNzLmtyIn0.VPbjqRFUMB2BoH2KdD5l1pm_VWmAazuEI7Fzs55mSodSR5UUK1HXdoTz2qb7sEUJjPt1TMNUaQOlsRVdYgy7jp042Cb73dxNwK1GdSm1HDz2lqKpRMTXVncqKD_qnhU0_8uvQpChqTvZfxUqHdQZ6S2uXKUvimEZjJ6uRsyaqrjtY3UES96jfGJSsv6J3nPhdd4FSjcY1rTBMnKAc3WDIKZFe3XbSq5yNP4nupjU5QoHGmRBXRcPBoJFMmXIRFeVimOQmmuY3V_CCZznLQEDpXP-Jc0lCUXKLsNa3V3d2NqZ8g4IS7nsv86lYhyuXjYrfzxAgCabyYxtZgjjw18gTg"


final class ViewController: UIViewController {

    // Cache
    private var user: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard request() == true else { return }
    }
    
    
    private func request() -> Bool {
        var request = URLRequest(httpMethod: .post, url: host)
        request.addValue(value: .applicationJSON, field: .contentType)
        
        let requestData = UserDataQuery(fields: [.id, .sub, .ageGroup, .createdDate, .name, .email, .phoneNumber, .gender, .identityId])
        
        return NetworkManager.shared.request(urlRequest: request, requestData: requestData, delegateQueue: nil) { (requested, response) in
            guard let decodableData = response?.data as? Data else { return }
            
            do {
                let responseData = try JSONDecoder().decode(GraphQLResponse<GetUser>.self, from: decodableData)
                guard let user = responseData.data?.user else {
                    log(.error, "Failed to get a response.")
                    return
                }
                
                self.user = user
                self.user.ageGroup = 50
                self.requestMutation()
                
            } catch let error {
                log(.error, error.localizedDescription)
                return
            }
        }
    }

    private func requestMutation() -> Bool {
        var request = URLRequest(httpMethod: .post, url: host)
        request.addValue(value: .applicationJSON, field: .contentType)
        let requestData = UserDataMutation(user: user, fields: [.id, .sub, .ageGroup, .createdDate, .name, .email, .phoneNumber, .gender])
        
        return NetworkManager.shared.request(urlRequest: request, requestData: requestData, delegateQueue: nil) { (requested, response) in
            guard let decodableData = response?.data as? Data else { return }
            
            do {
                let responseData = try JSONDecoder().decode(GraphQLResponse<GetUser>.self, from: decodableData)
                guard let user = responseData.data?.user else {
                    log(.error, "Failed to get a response.")
                    return
                }
                
                self.user = user
                
            } catch let error {
                log(.error, error.localizedDescription)
                return
            }
        }
    }
}



