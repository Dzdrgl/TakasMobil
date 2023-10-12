//
//  User.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 6/23/23.
//

import Foundation


struct User: Encodable, Decodable, Identifiable, Hashable{
    var id = UUID()
    var uid:String
    var email: String
    var username: String
    var profileImageUrl:String
    var country:String
}

struct UserData {
    var profileImageUrl: String
    var username: String
    var country: String
}
