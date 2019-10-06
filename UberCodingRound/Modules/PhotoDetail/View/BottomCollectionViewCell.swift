//
//  BottomCollectionViewCell.swift
//  UberCodingRound
//
//  Created by Shivam Srivastava on 02/10/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import UIKit

//Mark: Not being used as of now, but can be used to implement the images collection when the Image is in full screen
class BottomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(image: String?){
        if let photoUrl = image, let cacheImg = imageCache.object(forKey: photoUrl as AnyObject) as? UIImage {
            self.imageView.image = cacheImg
        }
    }
}
