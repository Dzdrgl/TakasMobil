//
//  SwipeAction.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 7/16/23.
//
//import SwiftUI
//
//struct SwipeActions<Content: View>: ViewModifier {
//    @Binding var offset: CGFloat
//    var content: () -> Content
//    var onDelete: () -> Void
//
//    @ViewBuilder
//    func body(content: Content) -> some View {
//        ZStack(alignment: .trailing) {
//            content
//                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
//                .offset(x: self.offset)
//                .gesture(
//                    DragGesture()
//                        .onChanged { value in
//                            self.offset = max(-UIScreen.main.bounds.width, min(0, value.translation.width))
//                        }
//                        .onEnded { value in
//                            if value.translation.width < -50 {
//                                withAnimation {
//                                    self.offset = -UIScreen.main.bounds.width
//                                }
//                            } else {
//                                withAnimation {
//                                    self.offset = 0
//                                }
//                            }
//                        }
//                )
//            
//            HStack {
//                Spacer()
//                Button(action: {
//                    onDelete()
//                    withAnimation {
//                        self.offset = 0
//                    }
//                }, label: {
//                    Image(systemName: "trash")
//                        .foregroundColor(.white)
//                })
//                .padding(.trailing, 20)
//            }
//            .frame(width: UIScreen.main.bounds.width, alignment: .trailing)
//            .background(Color.red)
//            .offset(x: self.offset)
//            .zIndex(2)
//        }
//    }
//}
//
//extension View {
//    func swipeActions(offset: Binding<CGFloat>, onDelete: @escaping () -> Void) -> some View {
//        self.modifier(SwipeActions(offset: offset, content: { self }, onDelete: onDelete))
//    }
//}
//
