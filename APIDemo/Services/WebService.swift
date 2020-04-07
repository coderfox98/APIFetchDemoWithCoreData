//
//  WebService.swift
//  APIDemo
//
//  Created by Rishabh Raj on 07/04/20.
//  Copyright © 2020 Rishabh Raj. All rights reserved.
//

import Foundation

class WebService {
    private init() { }
    
    static let shared = WebService()
    
    
    func getObjects(for page: Int, onSucess : @escaping([DemoObject]) -> Void, onFailure: @escaping(Error) -> Void) {
        guard let url = URL(string: "\(Constants.apiURLBaseString)\(page)&per_page=10") else {
            onFailure(NSError(domain: "Invalid URL", code: 101, userInfo: nil))
            return
        }
        
        let urlConfig = URLSessionConfiguration.default
         urlConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
         urlConfig.urlCache = nil
        
        let session = URLSession(configuration: urlConfig)
        
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                onFailure(error)
                return
            }
            guard let data = data else {
                onFailure(NSError(domain: "No Data Found", code: 101, userInfo: nil))
                return
            }
            do {
                let obj = try JSONDecoder().decode([DemoObject].self, from: data)
                DispatchQueue.main.async {
                    onSucess(obj)
                }
            }catch {
                onFailure(error)
            }
            
        }.resume()
    }
    
}
