//
//  Paging.swift
//  UberCodingRound
//
//  Created by Shivam Srivastava on 01/10/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import UIKit

class Paging: NSObject, NSCopying {
    
    var currentPage: Int = 1
    var totalPages: Int = 0
    var imagesPerPage: Int = 0
    var totalImages: Int = 0
    var maxPageLimit: Int
    
    init(maxPageLimit: Int = 3) {
        self.maxPageLimit = maxPageLimit
        super.init()
    }
    
    required init(original: Paging) {
        self.currentPage = original.currentPage
        self.totalPages = original.totalPages
        self.imagesPerPage = original.imagesPerPage
        self.totalImages = original.totalImages
        self.maxPageLimit = original.maxPageLimit
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let model = Paging(original: self)
        model.currentPage = self.currentPage
        model.totalPages = self.totalPages
        model.imagesPerPage = self.imagesPerPage
        model.totalImages = self.totalImages
        model.maxPageLimit = self.maxPageLimit
        return model
    }
    
}
