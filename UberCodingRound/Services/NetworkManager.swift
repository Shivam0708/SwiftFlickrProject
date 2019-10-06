//
//  NetworkManager.swift
//  UberCodingRound
//
//  Created by Shivam Srivastava on 28/09/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import UIKit

typealias ResponseType = ( _ sucess: Any?, _ error:ErrorResult?) -> Void

protocol APIPerformerProtocol {
    func perform(request: URLRequestConvertible, completionHandler: @escaping (Result<Data, ErrorResult>) -> Void) -> URLSessionTask?
}

class APISessionConfiguration: APISessionConfigurationProtocol {
    var baseURL: String {
        return BASE_URL
    }
}

class NetworkManager {
    private var sessionConfiguration: APISessionConfigurationProtocol
    private let apiPerformer: APIPerformerProtocol = APIPerformer()
    
    init(sessionConfiguration: APISessionConfigurationProtocol) {
        self.sessionConfiguration = sessionConfiguration
    }
    // Expose Services
    func searchService() -> SearchServiceProtocol {
        return SearchService(apiPerformer: apiPerformer, sessionConfiguration: sessionConfiguration)
    }
}


class APIPerformer: APIPerformerProtocol {
   
    init() {}
    
    func perform(request: URLRequestConvertible, completionHandler: @escaping (Result<Data, ErrorResult>) -> Void)  -> URLSessionTask?{
        do {
            let request = try request.asURLRequest()
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                if let error = error {
                    completionHandler(.failure(.network(string: "Something went wrong : " + error.localizedDescription)))
                    return
                }
                if let data = data {
                    completionHandler(.success(data))
                }
            })
            task.resume()
            return task
        } catch let error {
            print("Error: \(error)")
            return nil
        }
        
    }

    
}

