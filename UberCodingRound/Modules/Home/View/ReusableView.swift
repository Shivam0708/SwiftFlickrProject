//
//  ReusableView.swift
//  UberCodingRound
//
//  Created by Shivam Srivastava on 05/10/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import UIKit

protocol ReusableViewProtocol: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableViewProtocol where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}


extension UICollectionViewCell: ReusableViewProtocol { }
extension UITableViewCell: ReusableViewProtocol { }

