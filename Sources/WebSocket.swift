//
//  WebSocket.swift
//  botkit
//
//  Created by Dave DeLong on 1/22/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation
import Starscream

internal class WebSocket: NSObject {
    fileprivate var socket: Starscream.WebSocket
    fileprivate var socketError: NSError?
    fileprivate var receivedLastPong = true
    
    internal var onEvent: ((String) -> Void)?
    internal var onClose: ((NSError?) -> Void)?
    
    fileprivate let timerSource: DispatchSourceTimer
    fileprivate let pingInterval: TimeInterval
    
    init(socketURL: URL, pingInterval: TimeInterval) {
        self.socket = Starscream.WebSocket(url: socketURL)
        self.pingInterval = pingInterval
        self.timerSource = DispatchSource.makeTimerSource(flags: [], queue: .main)
        
        super.init()
        socket.delegate = self
    }
    
    func open() {
        socket.connect()
    }
    
    fileprivate func close() {
        socket.delegate = nil
        timerSource.cancel()
        onClose?(socketError)
    }
}

extension WebSocket: Starscream.WebSocketDelegate {
    func websocketDidConnect(socket: Starscream.WebSocket) {
        let intervalInNSec = pingInterval * Double(NSEC_PER_SEC)
        let startTime = DispatchTime.now() + Double(intervalInNSec) / Double(NSEC_PER_SEC)

        timerSource.scheduleRepeating(deadline: startTime, interval: pingInterval, leeway: .nanoseconds(Int(NSEC_PER_SEC / 10)))
        timerSource.setEventHandler { [unowned self] in
            if self.receivedLastPong == false {
                // we did not receive the last pong
                // abort the socket so that we can spin up a new connection
                self.socket.disconnect()
            } else {
                // we got a pong recently
                // send another ping
                self.receivedLastPong = false
                self.socket.write(ping: Data())
            }
        }
        timerSource.resume()
    }

    func websocketDidDisconnect(socket: Starscream.WebSocket, error: NSError?) {
        if let error = error {
            // save the error we can pass it back through the onClose closure
            socketError = error as NSError
        }

        // tear it all down
        close()
    }

    func websocketDidReceiveMessage(socket: Starscream.WebSocket, text: String) {
        onEvent?(text)
    }

    func websocketDidReceiveData(socket: Starscream.WebSocket, data: Data) {
        // we don't particularly care about data messages, so we do nothing
    }
}

extension WebSocket: Starscream.WebSocketPongDelegate {
    func websocketDidReceivePong(socket: Starscream.WebSocket, data: Data?) {
        self.receivedLastPong = true
    }
}

