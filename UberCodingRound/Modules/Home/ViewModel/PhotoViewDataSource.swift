//
//  PhotoViewDataSource.swift
//  UberCodingRound
//
//  Created by Shivam Srivastava on 05/10/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//


import UIKit

class GenericDataSource<T>: NSObject {
    var data: DynamicValue<[T]> = DynamicValue([])
}

class PhotosViewDataSource: GenericDataSource<Photo>, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let photo = self.data.value[indexPath.row]
        if let imgUrl = photo.imageUrl, let val = photo.id, let id = Int(val) {
            cell.imageView.tag = id
            cell.imageView.loadingImageUsingCacheWithUrlString(string: imgUrl)
        }
        return cell
    }
    
}
