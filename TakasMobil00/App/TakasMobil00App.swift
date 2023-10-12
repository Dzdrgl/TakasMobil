//
//  TakasMobil00App.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 5/22/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth


@main
struct TakasMobil00App: App {
    @StateObject private var sessionStore = SessionStore()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sessionStore)
                .onAppear {
                    sessionStore.listen()
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
}
