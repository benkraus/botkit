//
//  Startup.swift
//  botkit
//
//  Created by Dave DeLong on 10/5/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public struct Startup: EventType {
    
    public init(json: JSON, bot: Bot) throws {
        try json.match(type: "hello")
    }
    
}
