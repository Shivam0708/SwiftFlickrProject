//
//  Constants.swift
//  UberCodingRound
//
//  Created by Shivam Srivastava on 28/09/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import UIKit


typealias ResponseBlock = (_ responseObject:Any?,_ error:Error?)->Void
let TUPLE_FOR_MORE_PHOTO =  10

let kMinInteritemSpacingForSection: CGFloat = 10
let kSearchBarPlaceholder = "Search here"
let kTwoImage = "Two Images Per Row"
let kThreeImage = "Three Images Per Row"
let kFourImage = "Four Images Per Row"
let kFontAvenir = "Avenir Next"
let CANCEL = "Cancel"
let API_KEY = "3e7cc266ae2b0e0d78e279ce8e361736"
let BASE_URL = "http://api.flickr.com/services/rest/"


struct FlickrAPIKeys {
    static let SearchMethod = "method"
    static let APIKey = "api_key"
    static let Extras = "extras"
    static let ResponseFormat = "format"
    static let DisableJSONCallback = "nojsoncallback"
    static let SafeSearch = "safe_search"
    static let Text = "text"
    static let Page = "page"
}

struct FlickrAPIValues {
    static let SearchMethod = "flickr.photos.search"
    static let APIKeyID = API_KEY
    static let ResponseFormat = "json"
    static let DisableJSONCallback:String! = "1"
    static let MediumURL = "url_m"
    static let SafeSearch = "1"
}

enum ViewControllerDetail {
    
    case photoPageContainerVC
    case photoZoomVC
    
    var identifier: String {
        switch self {
        case .photoPageContainerVC:
            return "PhotoPageContainerViewController"
        case .photoZoomVC:
            return "PhotoZoomViewController"
        }
    }
    
    var storyBoard: String {
        switch self {
        case .photoPageContainerVC, .photoZoomVC:
            return "Main"
        }
    }
    
    
}
