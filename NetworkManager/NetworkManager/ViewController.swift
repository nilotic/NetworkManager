//
//  ViewController.swift
//  NetworkManager
//
//  Created by Den Jo on 15/07/2018.
//  Copyright © 2018 Den Jo. All rights reserved.
//

import UIKit

let authorization = "eyJraWQiOiJQR0ErZ0tXbUcwaW5nWEhrc0pBbTFQYmJ2ek1tYUlRWmJzRXNaRkJ2Z1FFPSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiJlNmRjNTQ4Mi1jMmExLTQ1MWYtYjAwNy0wMzRhMTY5ZDAxZTMiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImlzcyI6Imh0dHBzOlwvXC9jb2duaXRvLWlkcC5hcC1ub3J0aGVhc3QtMi5hbWF6b25hd3MuY29tXC9hcC1ub3J0aGVhc3QtMl9SSzgxVkhjOWkiLCJwaG9uZV9udW1iZXJfdmVyaWZpZWQiOnRydWUsImNvZ25pdG86dXNlcm5hbWUiOiJlNmRjNTQ4Mi1jMmExLTQ1MWYtYjAwNy0wMzRhMTY5ZDAxZTMiLCJhdWQiOiIycm5kaG45M2QzODZsaTYyazU1cTgwamlhaCIsInRva2VuX3VzZSI6ImlkIiwiYXV0aF90aW1lIjoxNTMxODExNDE0LCJuYW1lIjoi7KGw7YOc7ZiVIiwicGhvbmVfbnVtYmVyIjoiKzgyMTA2MzU0MTY5NiIsImV4cCI6MTUzMTkwMzE1MSwiaWF0IjoxNTMxODk5NTUxLCJlbWFpbCI6ImRlbkBiZWF1dHlwYXNzLmtyIn0.VS82PQemRWgIWqJq71psD3s5vqPLaG9wUNyAA7xiubJgaRWq-Q-eql5rVEi-IDeiCIPIGNG__SzeAitRiQSNAxptXb6aQ5UzHxL2wlJbf6O9yWjLbfe6bX8DKFSdYSbE-ScjzSd_FJQI9orjqxQ6m7E2LmdU86RFHrteZ_fT9QqNbwwKh09YSzs0WO677QeW7O0PcZLqB49ROuGUTtpvkS-SKuxNqygTFXlY0L1jqvA_n2LArme0v-hFRazmFD5yyPvCy8A7hTprJUIaK_j1SRVEE59woqR0pB_w9nXJvvbBRjuZEYZJ0IK7A752nqo_9qP7Ngx1v315aV9aB3x90A"


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



