//
//  FeedView.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 7/9/23.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var session: SessionStore
    @StateObject var profileService = ProfileService()
    @State private var selectedPost: PostModel?
    var gradient: LinearGradient{
        return LinearGradient(gradient: Gradient(colors: [Color.blue, Color.gray, Color.blue]), startPoint: .top, endPoint: .bottom)
    }
    
    
    var body: some View {
        NavigationStack {
            ScrollView{
                LazyVStack(spacing: 8){
                    ForEach(profileService.updatedPosts){ post in
                        FeedCellView(post: post)
                        Divider()
                        
                    }
                }
                .navigationTitle("AnaSayfa")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("TAKAS")
                            .font(.system(size: 28, weight: .heavy, design: .rounded))
                            .foregroundColor(.green.opacity(0.8))
                    }
                }
            }
            .background(gradient.opacity(0.3).ignoresSafeArea(.all))
            .onAppear{
                profileService.updateFeed()
                profileService.loadAllPosts()
            }
            
        }
    }
}

