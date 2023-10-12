//
//  LogInView.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 6/23/23.
//

import SwiftUI
import FirebaseAuth

struct LogInView: View {
    @EnvironmentObject var sessionStore: SessionStore
    @State private var showingAlert = false
    @State private var error: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    func errorCheck() -> String? {
        if email.trimmingCharacters(in: .whitespaces).isEmpty || password.trimmingCharacters(in: .whitespaces).isEmpty {
            return "E-Posta veya Şifre eksik."
        }
        return nil
    }

    func clear() {
        email = ""
        password = ""
    }
    
    func signIn() {
        if let error = errorCheck() {
            self.error = error
            showingAlert = true
            return
        }
        
        AuthService.signIn(email: email, password: password, onSuccess: { (user) in
            DispatchQueue.main.async {
                self.clear()
                sessionStore.session = user

            }
        }) { errorMessage in
            DispatchQueue.main.async {
                print("Error: \(errorMessage)")
                error = errorMessage
                showingAlert = true
            }
        }
        
    }
    var body: some View {
        NavigationView {
            VStack {
                Text("Takas")
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 50)
                
                Spacer()
                
                VStack {
                    HStack {
                        Image(systemName: "person")
                            .font(.system(size: 38))
                        
                        TextField("E-Posta", text: $email)
                            .textFieldStyle(MyTextFieldStyle())
                            .padding(.trailing, 30)
                            .autocapitalization(.none)

                    }
                    
                    HStack {
                        Image(systemName: "lock")
                            .font(.system(size: 38))
                        
                        SecureField("Şifre", text: $password)
                            .textFieldStyle(MyTextFieldStyle())
                            .padding(.trailing, 30)
                    }
                    
                    HStack {
                        Spacer()
                        
                        NavigationLink("Şifremi Unuttum", destination: ForgetPassView())
                            .padding(.top, 5)
                            .padding(.trailing, 35)
                            .font(.caption)
                    }
                }
                .padding()
                Button(action: {
                    signIn()
                }){
                    Text("Giriş Yap")
                        .padding()
                        .foregroundColor(.white)
                        .frame(width: 160, height: 60)
                        .background(.blue.opacity(0.85))
                        .font(.title)
                        .cornerRadius(10)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Hata"), message: Text(error), dismissButton: .default(Text ("Tamam") ) )
                }
                Spacer()
                NavigationLink(destination: SignUpView()) {
                    Text("HALA ÜYE OLMADIN MI?\n KAYIT OL")
                        .font(.system(.title3))
                        .padding()
                }
            }
            .background(BackgroundRadial.gradient)
            .navigationBarBackButtonHidden(true)

        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
