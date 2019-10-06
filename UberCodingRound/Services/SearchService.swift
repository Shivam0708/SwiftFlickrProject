//
//  SearchService.swift
//  UberCodingRound
//
//  Created by Shivam Srivastava on 02/10/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import Foundation

protocol SearchServiceProtocol {
    func searchText(query: String, paging: Paging, completion: @escaping ((Result<SearchResultsModel, ErrorResult>) -> Void))  -> URLSessionTask?
}

class SearchService: BaseService, SearchServiceProtocol, NetworkHandlerProtocol {
    
    func searchText(query: String, paging: Paging, completion: @escaping ((Result<SearchResultsModel, ErrorResult>) -> Void))  -> URLSessionTask? {
        // 1. Create Request Component
        let requestComponent = SearchRequestComponent.search(query: query, page: paging.currentPage)
        // 2. Create a request object
        let request = URLRequestBuilder(components: requestComponent, sessionConfiguration: sessionConfiguration)
        // 3. Perform the request using APIPerformerProtocol
        return apiPerformer.perform(request: request, completionHandler: self.networkResult(completion: completion))
    }
    
}
