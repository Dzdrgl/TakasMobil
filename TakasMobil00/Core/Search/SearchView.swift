//
//  SearchView.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 7/9/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    var gardient: LinearGradient{
        return LinearGradient(gradient: Gradient(colors: [Color.gray, Color.blue, Color.white, Color.green]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    @StateObject var viewModel = SearchService()
    
    @State private var searchingText = ""
    @State private var searchResults: [User] = []
    private let gridItems: [GridItem] = [
        GridItem(.flexible(), spacing: 1),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 5) {
                    ForEach(searchResults, id: \.self) { user in
                        NavigationLink(destination: ProfileView(user: user)) {
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
                                    
                                    Text(user.country)
                                        .font(.footnote)
                                    
                                }
                                Spacer()
                            }
                            .foregroundColor(.black)
                            .padding(.horizontal)
                        }
                    }
                }
                
                .padding(.top, 10)
                .searchable(text: $searchingText, prompt: "Ara...")
                .onChange(of: searchingText) { newText in
                    // Filter the allUser array based on the entered text
                    if newText.isEmpty {
                        searchResults = viewModel.allUser
                    } else {
                        searchResults = viewModel.allUser.filter { user in
                            user.username.localizedCaseInsensitiveContains(newText)
                        }
                    }
                }
            }
            .background(gardient.opacity(0.5).blur(radius: 10).ignoresSafeArea(.all))
            .navigationTitle("Ara")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
