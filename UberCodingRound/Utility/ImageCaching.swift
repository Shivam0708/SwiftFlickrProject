//
//  UIImageExtension.swift
//  UberCodingRound
//
//  Created by Shivam Srivastava on 28/09/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import UIKit

struct TagInfo {
    let tag: Int
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    @objc func loadingImageUsingCacheWithUrlString(string: String) {
        if let cacheImg = imageCache.object(forKey: string as AnyObject) as? UIImage {
            self.image = cacheImg
            self.isUserInteractionEnabled = true
            return
        }
        self.downloadImg(from: string)
    }
    
    
    func downloadImg(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode, str: link)
    }
    
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit, str: String) {
        let tagInfo = TagInfo(tag: self.tag)
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            
            DispatchQueue.main.async() {
                imageCache.setObject(image, forKey: str as AnyObject)
                if (tagInfo.tag == self.tag) {
                    self.image = image
                    self.isUserInteractionEnabled = true
                }
            }
        }.resume()
    }
    
    
}


