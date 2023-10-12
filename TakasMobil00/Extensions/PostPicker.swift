//
//  PostPicker.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 7/16/23.
//

import Foundation
import SwiftUI

//struct PostPicker: UIViewControllerRepresentable{
//    
//    @Binding var pickedImage: Image
//    @Binding var showImagePicker: Bool
//    @Binding var imageData: Data
//    
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
//        
//    }
//    func makeCoordinator() -> PostPicker.Coordinator {
//        Coordinator(parent: self)
//    }
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        picker.allowsEditing = true
//        return picker
//    }
//    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//        var parent: ImagePicker
//        init(parent: ImagePicker) {
//            self.parent = parent
//        }
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            let uiImage  = info[.editedImage] as! UIImage
//            parent.pickedImage = Image(uiImage: uiImage)
//            
//            if let mediaData = uiImage.jpegData(compressionQuality: 0.5){
//                parent.imageData = mediaData
//            }
//            parent.showImagePicker = false
//        }
//    }
//}

