//
//  StorageService.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 6/23/23.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import SwiftUI


class StorageService{
    static var storage = Storage.storage()
    static var storageRef = storage.reference()
    
    static var storageProfile = storageRef.child("profile")
    static var storagePost = storageRef.child("posts")
    static var storageChat = storageRef.child("chat")
    
    static func storagePostId(postId:String) -> StorageReference {
        return storagePost.child(postId)
    }
    static func storageProfileId(userId:String) -> StorageReference {
        return storageProfile.child(userId)
    }
    static func storageChatId(chatId: String) -> StorageReference {
        return storageChat.child(chatId)
    }
    
    static func savePostImage(userId:String,geoLocation:String ,description: String, caption: String, postId: String, imageData: Data, metadata: StorageMetadata, storagePostRef: StorageReference, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void){
        
        storagePostRef.putData(imageData,metadata: metadata){ (StorageMetadata, error) in
            
            if error != nil{
                onError(error!.localizedDescription)
                return
            }
            
            storagePostRef.downloadURL{ (url, error) in
                
                if let metaImageUrl  = url?.absoluteString {
                    
                    let firestorePostRef = PostService.PostsUserId(userId: userId).collection("posts").document(postId)
                    
                    
                    let post = PostModel.init(
    
                        caption: caption,
                        likes: [:],
                        geoLocation: geoLocation,
                        description: description,
                        ownerId: userId,
                        postId: postId,
                        username: Auth.auth().currentUser!.displayName!,
                        profile: Auth.auth().currentUser!.photoURL!.absoluteString,
                        mediaUrl: metaImageUrl,
                        date: Date().timeIntervalSince1970,
                        likeCount: 0
                    )
                    
                    
                    guard let dict = try? post.asDictionary() else {return}
                    
                    firestorePostRef.setData(dict){ (error) in
                        if error != nil{
                            onError(error!.localizedDescription)
                            return
                        }
                        PostService.TimelineUserId(userId: userId).collection("timeline").document(postId) .setData(dict)
                        PostService.AllPosts.document(postId).setData(dict)
                        
                        onSuccess()
                    }
                    
                }
            }
        }
    }
    
    static func saveProfileImage(userId:String, username: String, email:String,country:String ,imageData: Data,
                                 metaData:StorageMetadata, storageProfileImageRef: StorageReference, onSuccess: @escaping(_ user: User)  -> Void, onError: @escaping(_ errorMessage: String) -> Void ) {
        
        storageProfileImageRef.putData(imageData,metadata: metaData){ (StorageMetadata, error) in
            
            if error != nil{
                onError(error?.localizedDescription ?? "")
                return
            }
            storageProfileImageRef.downloadURL { url, error in
                if let metaImageUrl = url?.absoluteString{
                    
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest(){
                        changeRequest.photoURL = url
                        changeRequest.displayName = username
                        changeRequest.commitChanges{
                            error in
                            if error != nil{
                                onError(error!.localizedDescription)
                                return
                            }
                            
                        }
                    }
                    
                    let firestoreUserId = AuthService.getUserId(userId: userId)
                    
                    let user = User.init(uid: userId, email: email, username: username, profileImageUrl: metaImageUrl, country: country )
                    
                    guard let dict = try?user.asDictionary() else
                    {return}
                    firestoreUserId.setData(dict){
                        error in
                        if error != nil{
                            onError(error!.localizedDescription)
                        }
                    }
                    onSuccess(user)
                }
                
            }
            
        }
    }
    static func editProfile(userId: String, username: String,country:  String, imageData: Data, metaData: StorageMetadata, storageProfileImageRef: StorageReference, onError: @escaping(_ errorMessage: String)-> Void){
        
        storageProfileImageRef.putData(imageData, metadata: metaData){ (StorageMetadata, error) in
            if error != nil{
                onError(error!.localizedDescription)
            }
            
            storageProfileImageRef.downloadURL { url, error in
                if let metaImageUrl = url?.absoluteString{
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest(){
                        changeRequest.photoURL = url
                        changeRequest.displayName = username
                        changeRequest.commitChanges{ error in
                            if error != nil{
                                onError(error!.localizedDescription)
                                return
                            }
                        }
                    }
                    let fireStoreUserId = AuthService.getUserId(userId: userId)
                    fireStoreUserId.updateData([
                        "profileImageUrl" : metaImageUrl,
                        "username" : username,
                        "country" : country
                    ])
                }
            }
        }
    }
    static func saveChatImage(imageData: Data, onSuccess: @escaping (URL) -> Void, onError: @escaping (Error) -> Void) {
        let chatImageId = UUID().uuidString
        let chatImageRef = storageChatId(chatId: chatImageId)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        chatImageRef.putData(imageData, metadata: metaData) { (meta, error) in
            if let error = error {
                onError(error)
                return
            }
            
            chatImageRef.downloadURL { (url, error) in
                if let error = error {
                    onError(error)
                    return
                }
                
                if let downloadURL = url {
                    onSuccess(downloadURL)
                }
            }
        }
    }
}
