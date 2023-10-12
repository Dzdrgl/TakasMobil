//
//  ProfileService.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 6/29/23.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class ProfileService: ObservableObject {
    @Published var posts: [PostModel] = []
    @Published var allPosts: [PostModel] = []
    @Published var updatedPosts : [PostModel] = []
    @Published var userChats: [Chat] = []
    
    func updateFeed() {
        updatedPosts = (allPosts).sorted(by: { $0.date > $1.date })
    }
    func loadUserPosts(userId: String) {
        PostService.loadUserPosts(userId: userId) { [weak self] posts in
            DispatchQueue.main.async {
                self?.posts = posts
            }
        }
    }
    
    func loadAllPosts() {
        PostService.getAllPosts(onSuccess: { posts in
            self.allPosts = posts
            self.updateFeed()
        }, onError: { errorMessage in
            print(errorMessage)
        })
    }
    
    
    @MainActor
    static func getAllUser(completion: @escaping (Result<[User], Error>) -> Void) {
        let userRef = Firestore.firestore().collection("users")
        userRef.getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                let error = NSError(domain: "UserDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Kullanici bilgileri bulunamadı."])
                completion(.failure(error))
                return
            }
            
            var users = [User]()
            
            for document in documents {
                guard let userData = try? User(fromDictionary: document.data()) else {
                    // Skip this document if it cannot be parsed as a User object
                    continue
                }
                users.append(userData)
            }
            
            completion(.success(users))
        }
    }
}


