//
//  CustomStyle.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 7/10/23.
//

import Foundation
import SwiftUI

struct MyTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Color.black.opacity(0.4))
            .foregroundColor(Color.black)
            .cornerRadius(10)
    }
}

struct BackgroundRadial {
    static var gradient: RadialGradient {
        return RadialGradient(gradient: Gradient(colors: [.blue, .green]), center: .top, startRadius: 0, endRadius: 400)
    }
}
struct BackgroundGradient{
    static var gardient: LinearGradient{
        return LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
struct TextView: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isEditable = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.backgroundColor = UIColor.gray
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView
        
        init(_ parent: TextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}
