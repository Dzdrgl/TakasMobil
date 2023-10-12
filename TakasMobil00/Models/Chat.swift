//
//  Chat.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 6/29/23.
//

import Foundation
import FirebaseAuth

struct Chat: Encodable, Decodable, Identifiable{
    
    init( messageId: String, textMessage: String, senderProfileUrl: String, senderId: String, senderUsername: String, recipientProfileUrl: String, recipientId: String, recipientUsername: String, timestamp: Double, isPhoto: Bool) {
        self.messageId = messageId
        self.textMessage = textMessage
        self.senderProfileUrl = senderProfileUrl
        self.senderId = senderId
        self.senderUsername = senderUsername
        self.recipientProfileUrl = recipientProfileUrl
        self.recipientId = recipientId
        self.recipientUsername = recipientUsername
        self.timestamp = timestamp
        self.isPhoto = isPhoto
    }
    
    
    var id = UUID()
    var messageId: String
    var textMessage: String
    var senderProfileUrl: String
    var senderId: String
    var senderUsername: String
    var recipientProfileUrl: String
    var recipientId: String
    var recipientUsername: String
    var timestamp: Double
    var isCurrentUser: Bool{ return Auth.auth().currentUser!.uid == senderId }
    var isPhoto: Bool
}
