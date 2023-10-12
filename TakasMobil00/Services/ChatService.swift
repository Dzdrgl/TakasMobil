//
//  ChatService.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 6/25/23.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import Combine



class ChatService: ObservableObject {
    
    @Published var userChats: [Chat] = []
    
    static let chatCollection = AuthService.storeRoot.collection("chats")
    static let messagesCollection = AuthService.storeRoot.collection("messages")
    static let conversationCollection = AuthService.storeRoot.collection("conversation")
    
    static func conversation(senderId: String, recipientId: String) -> CollectionReference {
        return chatCollection.document(senderId).collection("chats").document(recipientId).collection("conversation")
    }
    
    static func userMessages(userId: String) -> CollectionReference {
        return messagesCollection.document(userId).collection("messages")
    }
    
    static func messagesId(senderId: String, recipientId: String) -> DocumentReference {
        return messagesCollection.document(senderId).collection("messages").document(recipientId)
    }
    
    static func sendMessage(message: String, recipientId: String, recipientProfileUrl: String, recipientUsername: String, onSuccess: @escaping () -> Void, onError: @escaping (_ error: String) -> Void) {
        guard let senderId = Auth.auth().currentUser?.uid,
              let senderUsername = Auth.auth().currentUser?.displayName,
              let senderProfileUrl = Auth.auth().currentUser?.photoURL else {
            print("Sender information not found")
            return
        }
        
        let messageId = ChatService.conversation(senderId: senderId, recipientId: recipientId).document().documentID
        
        let chat = Chat(
            messageId: messageId,
            textMessage: message,
            senderProfileUrl: senderProfileUrl.absoluteString,
            senderId: senderId,
            senderUsername: senderUsername,
            recipientProfileUrl: recipientProfileUrl,
            recipientId: recipientId,
            recipientUsername: recipientUsername,
            timestamp: Date().timeIntervalSince1970,
            isPhoto: false
        )
        
        guard let dict = try? chat.asDictionary() else {
            print("Failed to convert chat to dictionary")
            return
        }
        
        ChatService.conversation(senderId: senderId, recipientId: recipientId).document(messageId).setData(dict) { error in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            
            let senderMessage = Message(
                lastMessage: message,
                isPhoto: false,
                timestamp: Date().timeIntervalSince1970,
                userId: senderId,
                userName: senderUsername,
                profileUrl: senderProfileUrl.absoluteString
            )
            
            guard let senderDict = try? senderMessage.asDictionary() else {
                print("Failed to convert sender message to dictionary")
                return
            }
            
            let recipientMessage = Message(
                lastMessage: message,
                isPhoto: false,
                timestamp: Date().timeIntervalSince1970,
                userId: recipientId,
                userName: recipientUsername,
                profileUrl: recipientProfileUrl
            )
            
            guard let recipientDict = try? recipientMessage.asDictionary() else {
                print("Failed to convert recipient message to dictionary")
                return
            }
            
            ChatService.messagesId(senderId: senderId, recipientId: recipientId).setData(senderDict)
            ChatService.messagesId(senderId: recipientId, recipientId: senderId).setData(recipientDict)
            
            onSuccess()
        }
    }
    
    @MainActor
    static func getConversations(senderId: String, recipientId: String, onSuccess: @escaping ([Chat]) -> Void, onError: @escaping (_ error: String) -> Void) {
        ChatService.conversation(senderId: senderId, recipientId: recipientId).addSnapshotListener { snapshot, error in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {
                onError("Unknown error occurred.")
                return
            }
            
            let chats = snapshot.documents.compactMap { document -> Chat? in
                guard let dict = document.data() as? [String: Any] else {
                    return nil
                }
                
                return try? Chat(fromDictionary: dict)
            }
            
            onSuccess(chats)
        }
    }


    
    func getMessages(onSuccess: @escaping([Message]) -> Void, onError: @escaping(_ error: String) -> Void, newMessage: @escaping (Message) -> Void, listener: @escaping(_ listenerHandle: ListenerRegistration) -> Void) {
        
        let listenerMessage = ChatService.userMessages(userId: Auth.auth().currentUser!.uid).order(by: "timestamp", descending: true).addSnapshotListener { qs, error in
            
            guard let snapshot = qs else {
                onError(error?.localizedDescription ?? "Unknown error occurred.")
                return
            }
            
            var messages: [Message] = []
            
            snapshot.documentChanges.forEach { (diff) in
                if diff.type == .added {
                    let dict = diff.document.data()
                    guard let decoded = try? Message.init(fromDictionary: dict)else {
                        return
                    }
                    
                    newMessage(decoded)
                    messages.append(decoded)
                }
                if diff.type == .modified {
                    print("Modified")
                }
                if diff.type == .removed {
                    print("Removed")
                }
            }
            
            onSuccess(messages)
        }
        
        listener(listenerMessage)
    }
}
