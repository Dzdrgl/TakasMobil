//
//  SessionStore.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 6/23/23.
//

import Foundation
import Combine
import FirebaseStorage
import FirebaseAuth

class SessionStore: ObservableObject {
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User? { didSet { self.didChange.send(self) } }
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen() {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                let firestoreUserId = AuthService.getUserId(userId: user.uid)
                firestoreUserId.getDocument { document, error in
                    if let dict = document?.data() {
                        guard let decodedUser = try? User(fromDictionary: dict) else { return }
                        self.session = decodedUser
                    }
                }
            } else {
                self.session = nil
            }
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            // Handle error
        }
    }
    
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func deint() {
        // Clean up resources
    }
}

