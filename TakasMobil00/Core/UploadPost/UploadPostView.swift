//
//  UploadPostView.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 7/10/23.
//

import SwiftUI

struct UploadPostView: View {
    var gradient: LinearGradient{
        return LinearGradient(gradient: Gradient(colors: [Color.green, Color.gray, Color.green]), startPoint: .top, endPoint: .bottom)
    }
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var showingActionSheet = false
    @State private var showingImagePicker = false
    
    @State private var imageData: Data = Data()
    @State private var pickedImage: Image?
    @State private var postImage: Image?
    
    @State private var caption = ""
    @State private var description = ""
    @State private var country = ""
    
    @State private var error: String = ""
    @State private var showAlert = false
    
    
    var body: some View {
        NavigationStack{
            VStack{
                Button{
                    showingActionSheet = true
                }label: {
                    
                    if let image = postImage {
                        image
                            .resizable()
                            .frame(width: 400 , height: 400)
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    } else {
                        ZStack{
                        
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.black)
                                .frame(width: 150, height: 150)
                        }
                    }
                    
                }
                
                TextField("Başlık bilgisini giriniz..", text: $caption)
                    .textFieldStyle(MyTextFieldStyle())
                    .foregroundColor(.black)
                    .padding(.horizontal)
                
                Text("İlan Açıklaması")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                TextEditor(text: $description)
                    .cornerRadius(10)
                    .frame(height: 100)
                    .padding(.horizontal)
                    
                Spacer()
                
                Button(action: {
                    uploadPost()
                }) {
                    Text("Yayinla")
                        .padding()
                        .frame(width: 150)
                        .foregroundColor(.blue)
                        .background(Color.green.opacity(0.4))
                }
                .clipShape(Capsule())
                
                Spacer()
            }
                .background(gradient.opacity(0.4))
                .navigationTitle("Yeni İlan")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            clear()
                        } label: {
                            Text("İptal")
                                .foregroundColor(.blue)
                        }
                    }
                }
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
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
    
    func loadImage() {
        guard let inputImage = pickedImage else { return }
        postImage = inputImage
    }
    
    func clear(){
        self.caption = ""
        self.description = ""
        self.imageData = Data()
        self.postImage = nil
                            
    }
    
    func errorCheck() -> String? {
        if caption.trimmingCharacters(in: .whitespaces).isEmpty || imageData.isEmpty {
            return "Lütfen tüm alanları doldurunuz."
        }
        return nil
    }
    
    func uploadPost() {
        if let error = errorCheck() {
            self.error = error
            showAlert = true
            clear()
            return
        }
        PostService.uploadPost(caption: caption, geoLocation: country, description: description, imageData: imageData, onSuccess:{
            clear()
            
        }){ errorMessage in
            self.error = errorMessage
            showAlert = true
            return
        }

    }
}

