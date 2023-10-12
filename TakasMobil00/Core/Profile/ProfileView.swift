//
//  ProfileView.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 7/9/23.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct ProfileView: View {
    
    var gradient: LinearGradient{
        return LinearGradient(gradient: Gradient(colors: [Color.gray, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    @StateObject var profileService = ProfileService()
    
    var user : User
    @State private var userPosts : [PostModel] = []
    
    private let gridItem: [GridItem] = [
        .init(.flexible(),spacing: 2),
        .init(.flexible(),spacing: 2),
        .init(.flexible(),spacing: 2)
    ]
    
    var body: some View {
        
        ScrollView{
            VStack{
                HStack{
                    VStack{
                        WebImage(url: URL(string: user.profileImageUrl))
                            .resizable()
                            .placeholder(Image(systemName: "person"))
                            .scaledToFit()
                            .frame(width: 130, height: 130)
                            .clipShape(Circle())
                        
                        VStack{
                            Text(user.username)
                                .font(.title)
                                .foregroundColor(.black)
                            Text(user.country)
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                    }
                }
                
                Text("İlanları")
                    .font(.headline.bold())
                    .padding()
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.blue.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Divider()
            }
            LazyVGrid(columns: gridItem) {
                ForEach(userPosts, id: \.id) { post in
                    WebImage(url: URL(string: post.mediaUrl))
                        .resizable()
                        .placeholder(Image(systemName: "photo"))
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                }
            }
        }
        .background(gradient.opacity(0.2))
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ChatView(user: user)) {
                    Image(systemName: "arrow.up.message")
                        .imageScale(.large)
                }
            }
        }
        .onAppear{
            loadUserPosts()
        }
    }
    private func loadUserPosts() {
        PostService.loadUserPosts(userId: user.uid) { posts in
            DispatchQueue.main.async {
                self.userPosts = posts
            }
        }
        
    }
}

