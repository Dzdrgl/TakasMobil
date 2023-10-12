//
//  SignUpView.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 6/23/23.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    let backGroundGradient = LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .topLeading, endPoint: .bottomTrailing)
    let temelVeriler = TemelVeriler()
    
    @State private var firebaseError: String?
    
    @State private var isShowingLogInView = false
    @State private var showingAlert = false
    @State private var error:String = ""
    
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var country: String = ""
    
    @State private var profileImage: Image?
    @State private var pickedImage: Image?
    @State private var showingActionSheet = false
    @State private var showingImagePicker = false
    @State private var imageData: Data = Data ()
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    func clear(){
        self.email     = ""
        self.username  = ""
        self.password  = ""
        self.imageData = Data()
        self.profileImage = Image(systemName: "person.circle.fill")
        
    }
    
    func loadImage(){
        guard let inputImage = pickedImage else {return
        }
        profileImage = inputImage
    }
    
    func errorCheck() -> String? {
        if username.trimmingCharacters(in: .whitespaces).isEmpty || password.trimmingCharacters (in: .whitespaces).isEmpty || email.trimmingCharacters (in: .whitespaces).isEmpty || imageData.isEmpty{
            
            return "Lütfen tüm alanları doldurunuz."
        }
        return nil
    }
    
    func signUp(){
        if let error = errorCheck() {
            self.error = error
            self.showingAlert = true
            return
        }
        
        AuthService.signUp(username: username, email: email, password: password, country: country, imageData: imageData, onSuccess: { user in
            self.clear()
            isShowingLogInView = true
            
        })
            {
            (errorMessage) in
            print("Error \(errorMessage)")
            self.error = errorMessage
            self.showingAlert = true
            return
        }
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                Text("Takas ")
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .shadow(color: Color.blue, radius: 5, x: 4, y: 4)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top,60)

                Group{
                    if profileImage != nil {
                        profileImage!.resizable().clipShape(Circle()).frame(width: 100, height: 100).padding().onTapGesture {
                            self.showingActionSheet = true
                        }
                    }else{
                        Image(systemName: "person.circle").resizable().clipShape(Circle())
                            .frame(width: 100, height: 100).padding().onTapGesture {
                            self.showingActionSheet = true
                        }
                    }
                }
                Group{
                    TextField("\(Image(systemName: "person")) Kullanıcı Adı", text: $username)
                    TextField("\(Image(systemName: "envelope")) E-Posta", text: $email)
                    SecureField("\(Image(systemName: "lock"))  Şifre ", text: $password)
                    Picker("Şehir seçin", selection: $country) {
                        ForEach(temelVeriler.ilAdlari, id: \.self) { result in
                            Text(result)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .blendMode(.colorBurn)
                .textFieldStyle(MyTextFieldStyle())
                .autocapitalization(.none)
                .padding(.init(top: 5, leading: 30, bottom: 5, trailing: 30))
    
                Button(action: {
                    Task{
                        signUp()
                    }
                }){
                    Text("Kayıt Ol")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 160, height: 60, alignment: .center)
                        .background(.blue)
                        .font(.title2)
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $isShowingLogInView){
                    LogInView()
                }
                .alert(isPresented: $showingAlert){
                    Alert(title: Text("Hata"), message: Text(error), dismissButton: .cancel(Text("Tamam")))
                }
                .padding()
                
                Spacer()
            }
            .background(backGroundGradient)
            .edgesIgnoringSafeArea(.all)
            
        }.sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(pickedImage: Binding(get: {
                pickedImage ?? Image(systemName: "")
            }, set: { newValue in
                pickedImage = newValue
            }), showImagePicker: $showingImagePicker, imageData: $imageData)
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text(""), buttons: [
                .default(Text("Fotoğraflardan seç")) {
                    self.sourceType = .photoLibrary
                    self.showingImagePicker = true
                },
                .cancel()
            ])
            
            
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
