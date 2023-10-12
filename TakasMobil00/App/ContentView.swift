//
//  ContentView.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 5/22/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sessionStore: SessionStore
    var body: some View {
        Group {
            if sessionStore.session != nil {
                MainTabView()
            } else {
                LogInView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
