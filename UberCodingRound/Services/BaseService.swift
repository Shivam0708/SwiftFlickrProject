//
//  BaseService.swift
//  UberCodingRound
//
//  Created by Shivam Srivastava on 02/10/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import Foundation

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
}

enum ErrorResult: Error {
    case network(string: String)
    case decoding(string: String)
    case other(string: String)
}


class BaseService {
    let apiPerformer: APIPerformerProtocol
    let sessionConfiguration: APISessionConfigurationProtocol
    
    required init(apiPerformer: APIPerformerProtocol, sessionConfiguration: APISessionConfigurationProtocol) {
        self.apiPerformer = apiPerformer
        self.sessionConfiguration = sessionConfiguration
    }
    
}

