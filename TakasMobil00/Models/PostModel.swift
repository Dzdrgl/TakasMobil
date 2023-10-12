//
//  Post.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 6/26/23.
//
import Foundation

class PostModel: Encodable, Decodable,Identifiable{
    init(caption: String, likes: [String : Bool], geoLocation: String, description: String,ownerId: String, postId: String, username: String, profile: String, mediaUrl: String, date: Double, likeCount: Int) {
        self.caption = caption
        self.likes = likes
        self.geoLocation = geoLocation
        self.description = description
        self.ownerId = ownerId
        self.postId = postId
        self.username = username
        self.profile = profile
        self.mediaUrl = mediaUrl
        self.date = date
        self.likeCount = likeCount
    }
    
    var caption: String
    var likes : [String : Bool]
    var geoLocation: String
    var description: String
    var ownerId: String
    var postId: String
    var username: String
    var profile: String
    var mediaUrl: String
    var date: Double
    var likeCount: Int
    
}


