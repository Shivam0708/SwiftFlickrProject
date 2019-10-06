//
//  HomeViewModel.swift
//  UberCodingRound
//
//  Created by Shivam Srivastava on 28/09/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import UIKit


class HomeViewModel {
    
    weak var dataSource: GenericDataSource<Photo>?
    var photoViewModel:PhotoViewModel
    
    init(dataSource: GenericDataSource<Photo>?) {
        self.dataSource = dataSource
        self.photoViewModel = PhotoViewModel(dataSource: dataSource)
    }
    
    func fetchImageFromFlickr(searchText: String, completion:@escaping ResponseType) {
        //Use to fetch photos from fliker api
        photoViewModel.fetchPhotos(searchText: searchText) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let searchResModel) :
                    completion(searchResModel, nil)
                case .failure(let error) :
                    completion(nil, error)
                }
            }
        }
    }

    
}

