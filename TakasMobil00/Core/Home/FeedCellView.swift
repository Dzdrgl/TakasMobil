//
//  FeedCellView.swift
//  TakasMobil00
//
//  Created by Adem Dizdaroğlu on 7/9/23.
//
import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth

struct FeedCellView: View {
    @ObservedObject var postCardService: PostCardService
    @State private var animate = false
    private let duration: Double = 0.3
    
    private var animationScale: CGFloat {
        postCardService.isLiked ? 0.5 : 2.0
    }
    var post: PostModel
        
    @State private var user: User?
    
    init(post: PostModel) {
        self.post = post
        self.postCardService = PostCardService(post: post)
    }
    
    var body: some View {
        VStack {
            HStack {
                if let unwrappedUser = user {
                    NavigationLink(destination: ProfileView(user: unwrappedUser)) {
                        WebImage(url: URL(string: post.profile))
                            .resizable()
                            .placeholder(Image(systemName: "person.fill"))
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .shadow(color: .green, radius: 3)
                    }
                }
                Spacer()
                VStack {
                    Text(post.username)
                        .font(.title3)
                    VStack {
                        Text(user?.country ?? "" )
                        Text(Date(timeIntervalSince1970: post.date).timeAgo() + " önce")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                VStack {
                    Button(action: {
                        self.animate = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.duration) {
                            self.animate = false
                            
                            if self.postCardService.isLiked {
                                self.postCardService.unlike()
                            } else {
                                self.postCardService.like()
                            }
                        }
                        
                    }) {
                        Image(systemName: (self.postCardService.isLiked) ? "heart.fill" : "heart")
                            .frame(width: 30, height: 30, alignment: .center)
                            .foregroundColor((self.postCardService.isLiked) ? .red : .black)
                    }
                    .scaleEffect(animate ? animationScale : 1)
                    .animation(.easeIn(duration: duration))
                    
                    Text("\(self.postCardService.post.likeCount) fav")
                        .font(.footnote)
                }
            }
            .padding(.leading, 5)
            .padding(.trailing, 5)
            
            
            NavigationLink(destination: FeedDetailView(post: post)) {
                WebImage(url: URL(string: post.mediaUrl))
                    .resizable()
                    .placeholder(Image(systemName: "camera"))
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.size.width, height: 400, alignment: .center)
                    .clipped()
                
            }
            .offset(y: -10)
            
            
            VStack {
                Text(post.caption)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.footnote)
                Text(post.description)
                    .padding(.top, 1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.footnote)
            }
            .padding(.bottom,10)
            .padding(.leading, 10)
            .padding(.trailing,10)
        }
        .onAppear{
            AuthService.userData(userId: post.ownerId) { result in
                switch result {
                case .success(let user):
                    self.user = user
                case .failure(let error):
                    print("Error retrieving user data: \(error.localizedDescription)")
                }
            }
        }
     
        
    }
}
