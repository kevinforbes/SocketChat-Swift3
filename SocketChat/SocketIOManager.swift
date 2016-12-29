//
//  SocketIOManager.swift
//  SocketChat
//
//  Created by Kevin Forbes on 2016-12-29.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "http://192.168.1.133:3000")!)
    
    override init() {
        super.init()
    }
    
    func establishConnection(){
        socket.connect()
    }
    
    func closeConnection(){
        socket.disconnect()
    }
    
    func connectToServerWithNickname(_ nickname:String, completionHandler: @escaping (_ userList: [[String: AnyObject]]?) -> Void )  {
        socket.emit("connectUser", nickname)
        
        socket.on("userList") {(dataArray, ack) -> Void in
            completionHandler(dataArray[0] as? [[String: AnyObject]])
        }
    }
    
    
    
}
