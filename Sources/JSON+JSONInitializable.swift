//
//  JSON+JSONInitializable.swift
//  botkit
//
//  Created by Dave DeLong on 10/19/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public extension JSON {
    
    func value<T: JSONInitializable>(for key: String) throws -> T {
        guard let dict = self.object else { throw JSONError("Value is not an object") }
        return try T.init(json: dict[key] ?? .unknown)
    }
    
    func value<T: JSONInitializable>(for key: String) throws -> Array<T> {
        guard let dict = self.object else { throw JSONError("Value is not an object") }
        guard let arr = dict[key]?.array else { throw JSONError("Value for key \"\(key)\" not an array") }
        return try arr.map { try T.init(json: $0) }
    }
    
    
    func value<T: JSONInitializable>(at index: Int) throws -> T {
        guard let arr = self.array else { throw JSONError("Value is not an array") }
        guard index >= 0 && index < arr.count else { throw JSONError("Index \(index) is out of bounds") }
        return try T.init(json: arr[index])
    }
    
    func value<T: JSONInitializable>(at index: Int) throws -> Array<T> {
        guard let arr = self.array else { throw JSONError("Value is not an array") }
        guard index >= 0 && index < arr.count else { throw JSONError("Index \(index) is out of bounds") }
        guard let subArr = arr[index].array else { throw JSONError("Value at index \(index) is not an array") }
        return try subArr.map { try T.init(json: $0) }
    }
    
}
