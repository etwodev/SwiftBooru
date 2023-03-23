//
//  ImageModels.swift
//  SwiftBooru
//
//  Created by Ethan Woods on 22/03/2023.
//

import Foundation
import SwiftUI

struct PostView: View {
    @State private var isBookmarked: Bool
    @State private var animationRate: CGFloat = 0
    let post: BooruPost
    
    
    
    init(post: BooruPost) {
        self.isBookmarked = BookmarkManager(identifier: "Bookmarks").isBookmarked(post: post)
        self.post = post
    }
    
    var body: some View {
        VStack {
            ZStack {
                post.getPreview()
                
                Text("\(String(post.width))x\(String(post.height))")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .background(Color.highlightColor)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .contentShape(Rectangle())
                    .padding(3)
                    .onTapGesture(count: 2) {
                        animationRate = 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            animationRate = 0
                        }
                        if BookmarkManager(identifier: "Bookmarks").toggleBookmark(post: post) {
                            isBookmarked = BookmarkManager(identifier: "Bookmarks").isBookmarked(post: post)
                        } else {
                            print("Failure to toggle post!")
                        }
                    }
                    .overlay() {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.red)
                            .opacity(animationRate)
                            .animation(Animation.spring(), value: animationRate)
                        
                    }
                
                // Other on-image settings
                
            }
            Spacer()
            
            // Below text here
            
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 200)
        .padding(10)
        .background(Color.selectionColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


