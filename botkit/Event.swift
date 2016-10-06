//
//  EventType.swift
//  botkit
//
//  Created by Dave DeLong on 1/23/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public protocol EventType: JSONInitializable {
    
}

public extension JSON {
    
    func match(type: String) throws {
        if self["type"].string != type {
            throw JSONError(message: "Event type is not \(type)")
        }
    }
    
    func match(subtype: String) throws {
        if self["subtype"].string != subtype {
            throw JSONError(message: "Event subtype is not \(subtype)")
        }
    }
}
