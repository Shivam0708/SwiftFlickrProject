//
//  UIViewController.swift
//  UberCodingRound
//
//  Created by Shivam Srivastava on 05/10/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import UIKit

extension UIViewController {
    // Returns the error message
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) -> Void in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
