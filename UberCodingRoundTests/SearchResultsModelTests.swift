//
//  SearchResultsModelTests.swift
//  UberCodingRoundTests
//
//  Created by Shivam Srivastava on 06/10/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import XCTest
@testable import UberCodingRound

class SearchResultsModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEmptySearchResults() {
        let data = Data()
        let completion: ((Result<SearchResultsModel, ErrorResult>) -> Void) = { result in
            switch result {
            case .success:
                XCTAssert(false, "No data failure")
            default:
                break
            }
        }
        DecodableHelper.parse(data: data, completion: completion)
    }

    func testDecodeSearchResults() {
        guard let data = FileManager.readJsonFile(forResource: "flickrResponse") else {
            XCTAssert(false, "Can't get data from flickrResponse.json")
            return
        }
        let completion: ((Result<SearchResultsModel, ErrorResult>) -> Void) = { result in
            switch result {
            case .failure:
                XCTAssert(false, "Expected Valid SearchResultsModel")
            case .success(let response):
                if let searchResult = response.photosModel {
                    XCTAssertEqual(searchResult.page, 1, "Expected 1 page")
                    XCTAssertEqual(searchResult.pages, 3199, "Expected 3199 pages")
                    XCTAssertEqual(searchResult.perpage, 15, "Expected 15 perpage")
                    XCTAssertEqual(searchResult.total, "319856", "Expected 319856 total")
                    XCTAssertEqual(searchResult.photo!.count, 15, "Expected 15 photoResults")
                } else {
                    return  XCTAssert(false, "Unable to decode response")
                }
            }
        }
        DecodableHelper.parse(data: data, completion: completion)
    }
    
    
}


extension FileManager {
    static func readJsonFile(forResource fileName: String ) -> Data? {
        let bundle = Bundle(for: SearchResultsModelTests.self)
        if let path = bundle.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
            }
        }
        return nil
    }
}
