//
//  PostChatView.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 7/16/23.
//


import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import SDWebImageSwiftUI

struct PostChatView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    var user: User
    var post : PostModel
    @State private var message: String = ""
    @State private var chats: [Chat] = []
    @State private var recipientChats: [Chat] = []
    @State private var listener: ListenerRegistration?
    @State private var allChat: [Chat] = []
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .frame(width: 30, height: 30)
                }
                Spacer()
                WebImage(url: URL(string: user.profileImageUrl))
                    .resizable()
                    .placeholder(Image(systemName: "person"))
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 30, height: 30)
                Text(user.username)
                    .font(.title2)
                Spacer()
            }
            Divider()
            ScrollView {
                HStack{
                    VStack{
                        Text(post.caption)
                            .font(.title2)
                        Text(post.description)
                            .font(.body)
                            .lineLimit(2)
                    }.padding(.vertical,10)
                    Spacer()
                    
                    WebImage(url: URL(string:post.mediaUrl))
                        .resizable()
                        .placeholder(Image(systemName: "person"))
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 80, height: 80)
                }
                
                .padding(.all,5)
                .background(.blue.opacity(0.5))
                .cornerRadius(20)
                
                
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(allChat) { chat in
                        MessageBubble(chat: chat)
                            .padding(.leading, 8)
                            .padding(.trailing, 8)
                    }
                }
            }
            .padding(.vertical, 10)
            
            HStack {
                TextField("Type a message", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            
        }
        .background(BackgroundRadial.gradient.opacity(0.2))
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            loadUserChats(senderId: Auth.auth().currentUser!.uid, recipientId: user.uid)
            loadRecipientChats(senderId: user.uid, recipientId: Auth.auth().currentUser!.uid)
        }
        .onDisappear {
            stopListeningForMessages()
        }
    }
    
    
    @MainActor func loadUserChats(senderId: String, recipientId: String) {
        ChatService.getConversations(senderId: senderId, recipientId: recipientId) { chats in
            self.chats = chats
            updateAllChat()
        } onError: { error in
            print(error)
        }
    }
    
    @MainActor func loadRecipientChats(senderId: String, recipientId: String) {
        ChatService.getConversations(senderId: senderId, recipientId: recipientId) { chats in
            self.recipientChats = chats
            updateAllChat()
        } onError: { error in
            print(error)
        }
    }
    
    func updateAllChat() {
        allChat = (chats + recipientChats).sorted(by: { $0.timestamp < $1.timestamp })
    }
    
    func sendMessage() {
        guard !message.isEmpty, let currentUser = Auth.auth().currentUser else {
            return
        }
        
        // Append the new message to the existing array
        let newMessage = Message(
            lastMessage: message,
            isPhoto: false,
            timestamp: Date().timeIntervalSince1970,
            userId: currentUser.uid,
            userName: currentUser.displayName ?? "",
            profileUrl: currentUser.photoURL?.absoluteString ?? ""
        )
        
        ChatService.sendMessage(
            message: message,
            recipientId: user.uid,
            recipientProfileUrl: user.profileImageUrl,
            recipientUsername: user.username,
            onSuccess: {
                self.message = ""
            },
            onError: { error in
                print("Error sending message: \(error)")
            }
        )
    }
    
    func stopListeningForMessages() {
        listener?.remove()
    }
}

