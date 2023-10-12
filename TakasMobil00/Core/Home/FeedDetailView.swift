//
//  FeedDetailView.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 7/9/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct FeedDetailView: View {
    
    var post: PostModel
    @State private var user: User? = nil
    
    var body: some View {
        NavigationStack{
            ScrollView{
                HStack{
                    WebImage(url: URL(string: post.profile))
                        .resizable()
                        .placeholder(Image(systemName: "person"))
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .shadow(color: .blue, radius: 3)
                    Spacer()
                    VStack{
                        Text(post.username)
                            .font(.title2)
                            .foregroundColor(.black)
    
                        if user != nil{
                            Text(user!.country)
                                .font(.footnote)
                                .foregroundColor(.black)
                        }
                    }
                    Spacer()
                }
                .padding(.leading,8)
                .padding(.trailing,8)
                WebImage(url: URL(string: post.mediaUrl))
                    .resizable()
                    .placeholder(Image(systemName: "camera"))
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.size.width, height: 400, alignment: .center)
                    .clipped()
                VStack {
                    
                    Text(post.caption)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.footnote)
                    Text(post.description)
                        .padding(.top, 1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.footnote)
                }
                .padding(.vertical, 10)
                
               
                
            }
            .background(.gray.opacity(0.5))
            .navigationTitle("İlan Detayı")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                if let unwrappedUser = user {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: PostChatView(user: unwrappedUser, post: post)) {
                            Image(systemName: "arrow.up.message")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            
        }
        .onAppear{
            AuthService.userData(userId: post.ownerId) { result in
                switch result {
                case .success(let user):
                    self.user = user
                case .failure(let error):
                    print("Error retrieving user data: \(error.localizedDescription)")
                }
            }
        }
    }
}
