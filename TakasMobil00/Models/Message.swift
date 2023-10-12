//
//  Message.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 6/25/23.
//

import Foundation
import FirebaseAuth

struct Message : Encodable, Decodable, Identifiable{
    var id = UUID()
    var lastMessage: String
    var isPhoto: Bool
    var timestamp: Double
    var userId: String
    var userName: String
    var profileUrl: String
    var isCurrentUser: Bool{ return Auth.auth().currentUser!.uid == userId }
    
}
