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
    
    func exitChatWithNickName(_ nickname:String, completionHandler: @escaping () -> Void){
        socket.emit("exitUser", nickname)
        completionHandler()
    }
    
    func sendMessage(message: String, withNickName nickname: String){
        socket.emit("chatMessage", nickname, message)
    }
    
    func getChatMessage(_ completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
        socket.on("newChatMessage") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: AnyObject]()
            messageDictionary["nickname"] = dataArray[0] as AnyObject
            messageDictionary["message"] = dataArray[1] as AnyObject
            messageDictionary["date"] = dataArray[2] as AnyObject
            
            completionHandler(messageDictionary)
        }
    }
}
