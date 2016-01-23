//
//  Bot.swift
//  botkit
//
//  Created by Dave DeLong on 1/22/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public class Bot {
    private let connection: SlackConnection
    
    public init(authorizationToken: String) {
        connection = SlackConnection(token: authorizationToken)
        connection.onEvent = { [unowned self] in
            self.receiveEvent($0)
        }
    }
    
    private func receiveEvent(event: String) {
        NSLog("received: %@", event)
    }
    
}
