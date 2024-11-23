//
//  DataCoder.swift
//  RecipeApp
//
//  Created by Jonas S on 23/11/2024.
//

import Foundation

class DataCoder {
    
    static func encode<T: Encodable>(_ value: T) throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(value)
    }
    
    static func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
}
