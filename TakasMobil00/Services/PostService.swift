//
//  PostService.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 6/26/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class PostService{
    
    static var posts = AuthService.storeRoot.collection("posts")
    static var allPosts = AuthService.storeRoot.collection("allPosts")
    static var timeline = AuthService.storeRoot.collection("timeline")

    static func PostsUserId(userId: String) -> DocumentReference {
        return posts.document(userId)
    }
    static var AllPosts: CollectionReference {
            return allPosts
        }
    static func TimelineUserId(userId: String) -> DocumentReference {
        return timeline.document(userId)
    }

    static func uploadPost(caption: String, geoLocation:String, description:String, imageData: Data, onSuccess: @escaping()-> Void, onError: @escaping(_ errorMessage: String) -> Void){
        guard let userId = Auth.auth ().currentUser?.uid else {return}

        let postId = PostService.PostsUserId(userId: userId).collection("posts").document().documentID

        let storagePostRef = StorageService.storagePostId(postId: postId)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"

        StorageService.savePostImage(userId: userId,geoLocation: geoLocation,description:description, caption: caption, postId: postId, imageData: imageData, metadata: metadata, storagePostRef: storagePostRef, onSuccess: onSuccess , onError: onError)
    }

    static func loadPost(postId: String, onSuccess: @escaping(_ post: PostModel)-> Void) {
        PostService.allPosts.document(postId).getDocument { (snapshot, err) in
            guard let snap = snapshot else {
                print("Error")
                return
            }
            let dict = snap.data()
            guard let decoded = try? PostModel.init (fromDictionary: dict!)
            else{
                return
            }
            onSuccess(decoded)
        }
    }


    static func loadUserPosts(userId: String, onSuccess: @escaping(_ posts: [PostModel])-> Void){

        PostService.PostsUserId(userId: userId).collection("posts").getDocuments{ (snapshot, error) in
            guard let snap = snapshot  else{
                print("Error")
                return
            }

            var posts = [PostModel]()

            for doc in snap.documents{
                let dict = doc.data()
                guard let post = try? PostModel.init(fromDictionary: dict) else{
                    return
                }
                posts.append(post)
            }
            onSuccess(posts)
        }
    }
    static func deletePost(postId: String, onCompletion: @escaping (Bool) -> Void) {
        let postRef = posts.document(postId)
        
        postRef.delete { error in
            if let error = error {
                // Error occurred while deleting the post
                print("Error deleting post: \(error)")
                onCompletion(false)
            } else {
                // Successfully deleted the post
                onCompletion(true)
            }
        }
    }
    static func getAllPosts(onSuccess: @escaping ([PostModel]) -> Void, onError: @escaping (String) -> Void) {
        allPosts.getDocuments { (snapshot, error) in
            if let error = error {
                onError("Postları alma hatası: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                onError("Postlar bulunamadı.")
                return
            }

            var allPosts = [PostModel]()

            for doc in documents{
                let dict = doc.data()
                guard let post = try? PostModel.init(fromDictionary: dict) else{
                    return
                }
                allPosts.append(post)
            }
            onSuccess(allPosts)
        }
    }

}

