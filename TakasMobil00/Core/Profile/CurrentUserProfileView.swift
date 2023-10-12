//
//  CurrentUserProfileView.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 7/9/23.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI
struct CurrentUserProfileView: View {
    @EnvironmentObject var sessionStore: SessionStore
    @State private var showingProfile = false
    @State private var showingMyPost = false
    @State private var userData: UserData?
    var gradient: LinearGradient{
        return LinearGradient(gradient: Gradient(colors: [Color.blue, Color.gray, Color.blue]), startPoint: .top, endPoint: .bottom)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HStack {
                        VStack {
                            if let profileImageUrl = userData?.profileImageUrl {
                                WebImage(url: URL(string: profileImageUrl))
                                    .resizable()
                                    .placeholder(Image(systemName: "person"))
                                    .scaledToFit()
                                    .frame(width: 130, height: 130)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 130, height: 130)
                                    .clipShape(Circle())
                            }
                    
                            VStack {
                                if let username = userData?.username {
                                    Text(username)
                                        .font(.title)
                                        .foregroundColor(.black)
                                }
                                if let country = userData?.country {
                                    Text(country)
                                        .font(.title3)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                        
                    LazyVGrid(columns: [GridItem(.flexible())]) {
                        Group {
                            NavigationLink("Profili Düzenle") {
                                EditProfileView()
                            }
                            NavigationLink("İlanlarım") {
                                MyPostView()
                            }
                            Button(action: {
                                // Ayarlar
                            }) {
                                Text("Ayarlar")
                            }
                            Button(action: {
                                // Favoriler
                            }) {
                                Text("Favoriler")
                            }
                            Button(action: {
                                sessionStore.logOut()
                            }) {
                                Text("Çıkış Yap")
                                    .foregroundColor(.red)
                            }
                        }
                        .font(.headline.bold())
                        .padding()
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.blue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .padding()
                }
                
            }
            .background(gradient.opacity(0.2))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            AuthService.getUserData(userId: Auth.auth().currentUser!.uid) { result in
                switch result {
                case .success(let user):
                    userData = user
                case .failure(let error):
                    print("Error retrieving user data: \(error.localizedDescription)")
                }
            }
        }
    }
}

