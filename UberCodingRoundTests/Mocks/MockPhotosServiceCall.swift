//
//  MockPhotosServiceCall.swift
//  UberCodingRoundTests
//
//  Created by Shivam Srivastava on 06/10/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import XCTest
@testable import UberCodingRound


class MockPhotosServiceCall: PhotosServiceCallProtocol {
    var searchData: SearchResultsModel?
    func fetchPhotos(searchText searchTerm: String, paging: Paging, completion: @escaping ((Result<SearchResultsModel, ErrorResult>) -> Void)) {
        if let data = searchData {
            completion(Result.success(data))
        } else {
            completion(Result.failure(ErrorResult.other(string: "Unable to Parse")))
        }
    }
}
