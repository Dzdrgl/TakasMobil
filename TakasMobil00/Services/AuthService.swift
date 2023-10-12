//
//  AuthService.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 6/23/23.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class AuthService{
    
    static var storeRoot = Firestore.firestore()
    
    static func getUserId(userId: String) -> DocumentReference{
        return storeRoot.collection("users").document(userId)
    }
    static func signUp(username :String, email: String, password:String,country: String, imageData: Data, onSuccess: @escaping (_ user: User) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {
            (authData, error) in
            if error != nil { onError (error! .localizedDescription)
                return
            }
            guard let userId = authData?.user.uid else {return}
            
            let storageProfileUserId = StorageService.storageProfileId(userId: userId)
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            
            StorageService.saveProfileImage(userId: userId, username: username, email: email, country: country, imageData: imageData, metaData: metaData, storageProfileImageRef: storageProfileUserId, onSuccess: onSuccess, onError: onError)
        }
    }
    
    static func signIn(email: String, password: String, onSuccess: @escaping (_ user: User) -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authData, error) in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            
            guard let userId = authData?.user.uid else { return }
            
            let firestoreUserId = getUserId(userId: userId)
            firestoreUserId.getDocument { (document, error) in
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                
                if let dict = document?.data() {
                    if let decodedUser = try? User(fromDictionary: dict) {
                        onSuccess(decodedUser)
                    } else {
                        onError("Failed to decode user data")
                    }
                }
            }
        }
    }
    
    static func getUserData(userId: String, completion: @escaping (Result<UserData, Error>) -> Void) {
        let userRef = storeRoot.collection("users").document(userId)
        userRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists,
                  let country = document.data()?["country"] as? String,
                  let username = document.data()?["username"] as? String,
                  let profileImageUrl = document.data()?["profileImageUrl"] as? String else {
                
                let error = NSError(domain: "UserDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Kullanici bilgileri bulunamadı."])
                completion(.failure(error))
                return
            }
            
            let userData = UserData(profileImageUrl: profileImageUrl, username: username, country: country)
            completion(.success(userData))
        }
    }
    
    static func userData(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        let userRef = storeRoot.collection("users").document(userId)
        userRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists,
                  let uid = document.data()?["uid"] as? String,
                  let country = document.data()?["country"] as? String,
                  let username = document.data()?["username"] as? String,
                  let profileImageUrl = document.data()?["profileImageUrl"] as? String else {
                
                let error = NSError(domain: "UserDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Kullanici bilgileri bulunamadı."])
                completion(.failure(error))
                return
            }
            
            let userData = User(uid: uid, email: "", username: username, profileImageUrl: profileImageUrl, country: country)
            completion(.success(userData))
        }
    }
   
}
