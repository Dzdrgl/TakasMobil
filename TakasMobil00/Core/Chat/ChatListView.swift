//
//  ChatsView.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 7/12/23.
//
import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct ChatListView: View {
    var gradient: LinearGradient{
        return LinearGradient(gradient: Gradient(colors: [Color.blue, Color.gray, Color.blue]), startPoint: .top, endPoint: .bottom)
    }
    
    @StateObject var viewModel = SearchService()
    
    private let gridItems: [GridItem] = [
        GridItem(.flexible(), spacing: 1),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 5) {
                    ForEach(viewModel.allUser, id: \.self) { user in
                        if let currentUser = Auth.auth().currentUser, user.uid != currentUser.uid {
                            NavigationLink(destination: ChatView(user: user)) {
                                UserRowView(user: user)
                                    
                            }.padding(.leading, 10)
                                .padding(.trailing, 10)
                        }
                    }
                }
                .padding(.top, 10)
            }
            .navigationTitle("Chat")
            .navigationBarBackButtonHidden(true)
            .background(gradient.opacity(0.5))
            
        }
    }
}

struct UserRowView: View {
    let user: User
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: user.profileImageUrl))
                .resizable()
                .placeholder(Image(systemName: "person"))
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .shadow(color: .gray, radius: 3)
            
            VStack(alignment: .leading) {
                Text(user.username)
                    .fontWeight(.semibold)
                    .padding()
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .foregroundColor(.black)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.blue.opacity(0.5))
        .clipShape(Capsule())
    }
}
