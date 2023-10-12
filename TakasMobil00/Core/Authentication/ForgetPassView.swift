//
//  ForgetPassView.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 6/23/23.
//

import SwiftUI
import FirebaseAuth

struct ForgetPassView: View {
    let backGroundGradient = LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
    let buttonBackGroundGradient = LinearGradient(gradient: Gradient(colors: [Color.teal]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    @State private var ePosta = ""
    @State private var firebaseError: String?
    @State private var showingAlert = false
    @State private var baglantiGonderildiMi = false
    @State private var okTiklandi = false
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                TextField("E-Posta", text: $ePosta)
                    .padding()
                    .font(.title)
                    .foregroundColor(.white)
                    .textFieldStyle(MyTextFieldStyle())
                    .autocapitalization(.none)
                
                Spacer()
                Button("Kod Gönder") {
                    Task {
                        do {
                            try await Auth.auth().sendPasswordReset(withEmail: ePosta)
                            baglantiGonderildiMi = true
                        } catch let error {
                            showingAlert = true
                            firebaseError = error.localizedDescription
                        }
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("HATA"),
                        message: Text(firebaseError ?? ""),
                        dismissButton: .cancel(Text("Tamam"))
                    )
                }
                .alert(isPresented: $baglantiGonderildiMi) {
                    Alert(
                        title: Text("Doğrulama Kodu Gönderildi"),
                        message: Text("EPosta adresinize gönderilen linkten yeni şifrenizi belirleyiniz."),
                        dismissButton: .cancel(Text("Giriş Yap"), action: {
                            okTiklandi = true
                        })
                    )
                }
                .fullScreenCover(isPresented: $okTiklandi) {
                    LogInView()
                }
                .padding()
                .frame(width: 260, height: 60)
                .background(buttonBackGroundGradient.blur(radius: 20))
                .font(.system(size: 28))
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Spacer()
            }
            .background(backGroundGradient.ignoresSafeArea())
            
        }.navigationTitle("Sifremi Unuttum")
    }
}

struct ForgetPassView_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPassView()
    }
}
