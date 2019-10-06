//
//  PhotoViewModel.swift
//  UberCodingRound
//
//  Created by Shivam Srivastava on 01/10/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import UIKit

protocol PhotosServiceCallProtocol: class {
    func fetchPhotos(searchText: String, paging: Paging, completion: @escaping ((Result<SearchResultsModel, ErrorResult>) -> Void))
}

class PhotoViewModel {

    weak var service: PhotosServiceCallProtocol?
    weak var dataSource: GenericDataSource<Photo>?
    var photos = [Photo]()
    var totalCount: String?
    private var paging: Paging = Paging()
    var currentPage: Int {
        return  self.paging.currentPage
    }
    
    init(service: PhotosServiceCallProtocol? = PhotosServiceCall.shared, dataSource: GenericDataSource<Photo>?) {
        self.service = service
        self.dataSource = dataSource
    }

    func newRequest() {
        self.paging = Paging.init(maxPageLimit: 4)
        self.photos = []
    }
    
    func incrementPage() {
        self.paging.currentPage += 1
    }
    

    
    func fetchPhotos(searchText: String, completion: @escaping ((Result<SearchResultsModel, ErrorResult>) -> Void)) {
        
        service?.fetchPhotos(searchText: searchText, paging: paging, completion: { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let searchResModel) :
                    self?.totalCount = searchResModel.photosModel?.total
                    if let results = searchResModel.photosModel?.photo {
                        self?.photos.append(contentsOf: results.filter({$0.imageUrl != nil}))
                        self?.dataSource?.data.value = self?.photos ?? []
                        completion(result)
                    } else {
                        completion(Result.failure(ErrorResult.decoding(string: "Unable to parse")))
                    }
                case .failure(let error) :
                    completion(result)
                }
            }
        })
        
    }

    
}


class PhotosServiceCall: PhotosServiceCallProtocol {
    
    static let shared = PhotosServiceCall()
    var task: URLSessionTask?


    func fetchPhotos(searchText: String, paging: Paging, completion: @escaping ((Result<SearchResultsModel, ErrorResult>) -> Void)) {
        if paging.currentPage == 1 {
            self.cancelFetchService()
        }
        if paging.currentPage > paging.maxPageLimit {
            return
        }
        let network = NetworkManager(sessionConfiguration: APISessionConfiguration())
        self.task = network.searchService().searchText(query: searchText, paging: paging) { (result) in
            completion(result)
        }
        
    }
    
    func cancelFetchService() {
        if let task = task {
            task.cancel()
        }
        task = nil
    }
    
}
