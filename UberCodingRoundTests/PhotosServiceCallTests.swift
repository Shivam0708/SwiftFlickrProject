//
//  PhotosServiceCallTests.swift
//  UberCodingRoundTests
//
//  Created by Shivam Srivastava on 06/10/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import XCTest
@testable import UberCodingRound


class PhotosServiceCallTests: XCTestCase {

    func testCancelRequest() {
        let service: PhotosServiceCall! = PhotosServiceCall()
        service.fetchPhotos(searchText: "test", paging: Paging()) { (_) in
        }
        service.cancelFetchService()
        XCTAssertNil(service.task, "Expected task nil")
    }

}
