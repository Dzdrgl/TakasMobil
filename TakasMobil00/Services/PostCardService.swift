//
//  PostCard.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 6/30/23.
//

import Foundation
import FirebaseAuth
class PostCardService: ObservableObject{
    @Published var post: PostModel!
    @Published var isLiked = false

    init(post: PostModel) {
        self.post = post
        hasLikedPost()
    }
    
    func hasLikedPost() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            isLiked = false
            return
        }
        isLiked = (post.likes["\(Auth.auth().currentUser!.uid)"] == true) ? true : false
    }

    
    func like() {
        post.likeCount += 1
        isLiked = true
        
        PostService.PostsUserId(userId: post.ownerId).collection("posts").document(post.postId).updateData(["likeCount": post.likeCount, "\(Auth.auth().currentUser!.uid)": true])
        
        PostService.AllPosts.document(post.postId).updateData( ["likeCount": post.likeCount, "\(Auth.auth().currentUser!.uid)": true])
        
        PostService.TimelineUserId(userId: post.ownerId).collection("timeline").document(post.postId).updateData(["likeCount": post.likeCount, "\(Auth.auth().currentUser!.uid)": true])
    
    }


    func unlike() {
        post.likeCount -= 1
        isLiked = false
        
        PostService.PostsUserId(userId: post.ownerId).collection("posts").document(post.postId).updateData(["likeCount": post.likeCount, "\(Auth.auth().currentUser!.uid)": false])
        
        PostService.AllPosts.document(post.postId).updateData( ["likeCount": post.likeCount, "\(Auth.auth().currentUser!.uid)": false])
        
        PostService.TimelineUserId(userId: post.ownerId).collection("timeline").document(post.postId).updateData(["likeCount": post.likeCount, "\(Auth.auth().currentUser!.uid)": false])
    
    }
}
