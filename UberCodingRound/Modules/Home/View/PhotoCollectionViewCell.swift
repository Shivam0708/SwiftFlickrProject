//
//  PhotoCollectionViewCell.swift
//  UberCodingRound
//
//  Created by Shivam Srivastava on 28/09/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        self.imageView.tag = 0
        self.imageView.image = UIImage(named: "loadingImage")
        imageView.isUserInteractionEnabled = true
    }

    func configureCell() {
        
    }
    
}
