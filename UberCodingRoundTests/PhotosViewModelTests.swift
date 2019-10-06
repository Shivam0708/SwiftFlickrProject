//
//  PhotosViewModelTests.swift
//  UberCodingRoundTests
//
//  Created by Shivam Srivastava on 06/10/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import XCTest
@testable import UberCodingRound

class PhotosViewModelTests: XCTestCase {

    var viewModel: PhotoViewModel?
    var dataSource: GenericDataSource<Photo>?
    fileprivate var service: MockPhotosServiceCall?
    
    override func setUp() {
        super.setUp()
        self.service = MockPhotosServiceCall()
        self.dataSource = GenericDataSource<Photo>()
        self.viewModel = PhotoViewModel(service: service, dataSource: dataSource)
    }

    override func tearDown() {
        self.viewModel = nil
        self.dataSource = nil
        self.service = nil
        super.tearDown()
    }

    func testfetchPhotos() {
        service?.searchData = searchResultsModel
        viewModel?.fetchPhotos(searchText: "Initial Test") { (result)  in
            switch result {
            case .failure :
                XCTAssert(false, "ViewModel should not be able to fetch without service")
            default:
                break
            }
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}


private let photosModel = Photo(id: "41886638322", owner: "151109375", secret: "9e692e7e1d", server: "959", farm: 1, title: "Alice and Bob", ispublic: 1, isfriend: 0, isfamily: 0, imageUrl: "https://live.staticflickr.com/65535/48852126946_aec55a6b28.jpg")
private let resultsModel = PhotosModel(page: 1, pages: 4, perpage: 20, total: "50", photo: [photosModel])
private let searchResultsModel = SearchResultsModel(stat: "ok", photosModel: resultsModel)
