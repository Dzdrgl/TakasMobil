//
//  EditProfileView.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 7/12/23.
//

import SwiftUI

struct EditProfileView: View {
    @Environment (\.dismiss) var dismiss
    @State private var username: String = ""
    @State private var country: String = ""
    var body: some View {
        NavigationStack{
            VStack{
             
                EditProfileRowView(title: "kullanici adi", placeholder: "Kullanıcı adı girin..", text: $username)
                
            }
        }.navigationTitle("Profili Düzenle")
            .navigationBarBackButtonHidden(true)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Uygula") {
                        
                    }
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct EditProfileRowView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var body: some View {
        HStack {
            Text(title)
                .padding(.leading, 8)
                .frame (width: 100, alignment: .leading)
            VStack {
                TextField(placeholder, text: $text)
                Divider()
            }
        }
        .font(.subheadline)
        .frame(height: 35)
    }
}
struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
