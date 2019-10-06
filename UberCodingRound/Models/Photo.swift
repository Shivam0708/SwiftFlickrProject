//
//  Photo.swift
//  UberCodingRound
//
//  Created by Shivam Srivastava on 28/09/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import  Foundation

struct PhotosModel: Codable {
    var page: Int?
    var pages: Int?
    var perpage: Int?
    var total: String?
    var photo: [Photo]?
}

struct Photo: Codable {
    
    var id: String?
    var owner: String?
    var secret: String?
    var server: String?
    var farm: Int?
    var title: String?
    var ispublic: Int?
    var isfriend: Int?
    var isfamily: Int?
    var imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageUrl = "url_m"
        case owner
        case secret
        case server
        case farm
        case isfamily
        case isfriend
    }
    
}

struct SearchResultsModel: Codable {
    var stat: String?
    var photosModel: PhotosModel?
    
    enum CodingKeys: String, CodingKey {
        case stat
        case photosModel = "photos"
    }
    
}

extension SearchResultsModel: DecodableProtocol {
    static func decodeObject(data: Data) -> Result<SearchResultsModel, ErrorResult> {
        let decoder = JSONDecoder()
        do {
            if let result = try? decoder.decode(SearchResultsModel.self, from: data) {
                return Result.success(result)
            } else {
                return Result.failure(ErrorResult.decoding(string: "Unable to get flickr results"))
            }
        }
    }
}
