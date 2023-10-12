//
//  MyPostView.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 7/9/23.
//
import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct MyPostView: View {
    @State private var swipeOffset: CGFloat = 0
    
    @StateObject private var profileService = ProfileService()
    
    @State private var posts: [PostModel] = []
    
    var gradient: LinearGradient{
        return LinearGradient(gradient: Gradient(colors: [Color.blue, Color.gray, Color.blue]), startPoint: .top, endPoint: .bottom)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack{
                ForEach(posts, id: \.id) { post in
                    HStack{
                        Text(post.caption)
                            .font(.title2)
                            .padding()
                            .background(.blue.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(action: {
                            deletePost(post: post)
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                }
            }
            .padding(.vertical, 20)
        }
        .navigationTitle("İlanlarım")
        .navigationBarTitleDisplayMode(.inline)
        .background(gradient.blur(radius: 5).opacity(0.3).ignoresSafeArea(.all))
        .onAppear {
            loadUserPosts()
        }
    }
    private func loadUserPosts() {
        if let currentUser = Auth.auth().currentUser {
            PostService.loadUserPosts(userId: currentUser.uid) { posts in
                DispatchQueue.main.async {
                    self.posts = posts
                }
            }
        }
    }
    private func deletePost(post: PostModel) {
    }
}

