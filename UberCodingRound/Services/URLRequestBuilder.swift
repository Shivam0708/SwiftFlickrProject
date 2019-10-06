//
//  URLRequestBuilder.swift
//  UberCodingRound
//
//  Created by Shivam Srivastava on 02/10/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import Foundation

public protocol URLRequestConvertible {
    // - returns: A URL request.
    func asURLRequest() throws -> URLRequest
}

extension URLRequestConvertible {
    // The URL request.
    public var urlRequest: URLRequest? { return try? asURLRequest() }
}


class URLRequestBuilder: URLRequestConvertible {
    let components: URLRequestComponentsProtocol
    let sessionConfiguration: APISessionConfigurationProtocol
    
    required init(components: URLRequestComponentsProtocol, sessionConfiguration: APISessionConfigurationProtocol) {
        self.components = components
        self.sessionConfiguration = sessionConfiguration
    }
    
    func asURLRequest() throws -> URLRequest {
        let url: URL = URL(string: "\(sessionConfiguration.baseURL)\(components.path)\(components.queryParms)")!
        var urlReq: URLRequest = URLRequest(url: url)
        // 2. Assign HTTP Method
        urlReq.httpMethod = components.method.rawValue
        // 3. Add Headers
        urlReq.allHTTPHeaderFields = components.extraHeaders
        return urlReq
    }
    
}
