//
//  DecodableProtocol.swift
//  UberCodingRound
//
//  Created by Shivam Srivastava on 06/10/19.
//  Copyright © 2019 Shivam Srivastava. All rights reserved.
//

import Foundation

protocol DecodableProtocol {
    static func decodeObject(data: Data) -> Result<Self, ErrorResult>
}

final class DecodableHelper {
    
    static func parse<T: DecodableProtocol>(data: Data, completion: (Result<[T], ErrorResult>) -> Void) {
        switch T.decodeObject(data: data) {
        case .failure(let error):
            completion(.failure(error))
            break
        case .success(let newModel):
            completion(.success([newModel]))
            break
        }
    }
    
    static func parse<T: DecodableProtocol>(data: Data, completion: (Result<T, ErrorResult>) -> Void) {
        switch T.decodeObject(data: data) {
        case .failure(let error):
            completion(.failure(error))
            break
        case .success(let newModel):
            completion(.success(newModel))
            break
        }
    }
    
}
