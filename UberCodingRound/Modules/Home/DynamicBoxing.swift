//
//  DynamicBoxing.swift
//  UberCodingRound
//
//  Created by Shivam Srivastava on 05/10/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import Foundation

class DynamicValue<T> {
    typealias CompletionHandler = ((T) -> Void)
    var value: T {
        didSet {
            self.notify()
        }
    }
    
    private var observers = [String: CompletionHandler]()
    
    init(_ value: T) {
        self.value = value
    }
    
    private func notify() {
        observers.forEach({ $0.value(value) })
    }
    
    public func addObserver(_ observer: NSObject, completionHandler: @escaping CompletionHandler) {
        observers[observer.description] = completionHandler
    }
    
    public func addAndNotify(observer: NSObject, completionHandler: @escaping CompletionHandler) {
        self.addObserver(observer, completionHandler: completionHandler)
        self.notify()
    }
    
    
    deinit {
        observers.removeAll()
    }
}
