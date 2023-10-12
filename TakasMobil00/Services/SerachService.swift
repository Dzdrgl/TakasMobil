//
//  SerachService.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 7/12/23.
//
import SwiftUI
import Foundation
import FirebaseFirestore

class SearchService: ObservableObject{
    
    @Published var allUser: [User] = []
    
    init() {
        Task { try await fetchAllUsers() }
    }
    func  fetchAllUsers() async throws{
        let allUser = try? await  ProfileService.getAllUser { result in
            switch result {
            case .success(let users):
                self.allUser = users
            case .failure(let error):
                print("Error fetching users: \(error.localizedDescription)")
            }
        }
    }
}
struct IdentifiableString: Identifiable {
    let id: UUID
    let value: String
}

struct SearchBar: View {
    @Binding var text: String
    @Binding var isSearching: Bool

    var body: some View {
        HStack {
            TextField("Ara", text: $text)
                .padding(.leading, 24)
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(8)
        .padding(.horizontal)
        .onTapGesture {
            isSearching = true
        }
    }
}
