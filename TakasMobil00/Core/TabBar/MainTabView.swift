//
//  MainTabView.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 7/9/23.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView{
            FeedView()
                .tabItem{
                    Image(systemName: "house")
                }
            SearchView()
                .tabItem{
                    Image(systemName: "magnifyingglass")
                }
            UploadPostView()
                .tabItem{
                    Image(systemName: "plus.square")
                }
            ChatListView()
                .tabItem{
                    Image(systemName: "ellipsis.message")
                }
            CurrentUserProfileView()
                .tabItem{
                    Image(systemName: "person")
                }
        }
        .accentColor(.white)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
