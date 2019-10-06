//
//  NetworkHelper.swift
//  UberCodingRound
//
//  Created by Shivam Srivastava on 06/10/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import Foundation

protocol NetworkHandlerProtocol {}

extension NetworkHandlerProtocol {
    
    func networkResult<T: DecodableProtocol>(completion: @escaping ((Result<T, ErrorResult>) -> Void)) ->
        ((Result<Data, ErrorResult>) -> Void) {
            
        return { dataResult in
            DispatchQueue.global(qos: .background).async(execute: {
                switch dataResult {
                case .success(let data) :
                    DecodableHelper.parse(data: data, completion: completion)
                case .failure(let error) :
                    completion(.failure(.network(string: "Network error " + error.localizedDescription)))
                }
            })
        }
            
    }
    
    
    func networkResult<T: DecodableProtocol>(completion: @escaping ((Result<[T], ErrorResult>) -> Void)) ->
        ((Result<Data, ErrorResult>) -> Void) {
            
        return { dataResult in
            DispatchQueue.global(qos: .background).async(execute: {
                switch dataResult {
                case .success(let data) :
                    DecodableHelper.parse(data: data, completion: completion)
                case .failure(let error) :
                    completion(.failure(.network(string: "Network error " + error.localizedDescription)))
                }
            })
        }
            
    }
    
    
    
}
