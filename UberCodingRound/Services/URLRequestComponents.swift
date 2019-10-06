//
//  URLRequestComponents.swift
//  UberCodingRound
//
//  Created by Shivam Srivastava on 02/10/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import Foundation

protocol APISessionConfigurationProtocol {
    var baseURL: String { get }
}

protocol URLRequestComponentsProtocol {
    var method: HTTPMethod { get }    
    var path: String { get }
    var queryParms: String { get }
    var parameters: [String: String]? { get }
    var extraHeaders: [String: String]? { get }
}


enum SearchRequestComponent: URLRequestComponentsProtocol {
    case search(query: String, page: Int)
    
    var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .search:
            return ""
        }
    }
    
    var queryParms: String {
        switch self {
        case .search:
            // Add Query Parameters
            var searchParams = [String]()
            for (key, value) in parameters ?? [:] {
                if let stringValue = value as? String, stringValue.count > 0  {
                    searchParams.append("\(key)=\(stringValue)")
                }
            }
            let endPoint = (!searchParams.isEmpty ? "?" : "") + searchParams.joined(separator: "&")
            return endPoint
        }
    }
    
   
    var parameters: [String : String]? {
        switch self {
        case .search(let query, let page):
            let text = query.replacingOccurrences(of: " ", with: "%20")
            return [
                FlickrAPIKeys.SearchMethod : FlickrAPIValues.SearchMethod,
                FlickrAPIKeys.APIKey : FlickrAPIValues.APIKeyID,
                FlickrAPIKeys.Text : text,
                FlickrAPIKeys.Extras : FlickrAPIValues.MediumURL,
                FlickrAPIKeys.ResponseFormat : FlickrAPIValues.ResponseFormat,
                FlickrAPIKeys.DisableJSONCallback : FlickrAPIValues.DisableJSONCallback,
                FlickrAPIKeys.Page : "\(page)"
            ]
        }
    }
    
    var extraHeaders: [String : String]? {
        return nil
    }
    
    
}
