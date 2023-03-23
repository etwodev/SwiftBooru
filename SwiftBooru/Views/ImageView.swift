//
//  ImageModels.swift
//  SwiftBooru
//
//  Created by Ethan Woods on 22/03/2023.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import AppKit

struct PostView: View {
    @Binding var isShowingTag: Bool
    @Binding var currentPost: BooruPost?
    @State private var isBookmarked: Bool
    @State private var showSavePanel: Bool = false
    @State private var animationRate: CGFloat = 0
    let post: BooruPost
    
    
    
    init(post: BooruPost, isShowingTag: Binding<Bool>, currentPost: Binding<BooruPost?>) {
        self.isBookmarked = BookmarkManager(identifier: "Bookmarks").isBookmarked(post: post)
        self.post = post
        self._currentPost = currentPost
        self._isShowingTag = isShowingTag
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
                    .padding(3)

                VStack {
                    Menu {
                        Button("Add to Bookmarks") {
                            if BookmarkManager(identifier: "Bookmarks").toggleBookmark(post: post) {
                                isBookmarked = BookmarkManager(identifier: "Bookmarks").isBookmarked(post: post)
                            } else {
                                print("Post has been successfully favourited at : \(post.id)")
                            }
                        }
                        Button("Show Details...") {
                            isShowingTag = true
                            currentPost = post
                        }
                        Divider()
                        Button("Save Image As...") {
                            let url = URL(string: post.file)
                            let savePanel = NSSavePanel()
                            savePanel.allowedContentTypes = [UTType.video, UTType.movie, UTType.image, UTType.gif]
                            savePanel.canCreateDirectories = true
                            savePanel.isExtensionHidden = false
                            savePanel.allowsOtherFileTypes = false
                            savePanel.title = "Save File"
                            savePanel.prompt = "Save"
                            savePanel.nameFieldLabel = "File name:"
                            savePanel.nameFieldStringValue = post.image
                            
                            // Present the save panel as a modal window.
                            savePanel.begin { response in
                                if response == .OK {
                                    FileDownloader.loadFileAsync(url: url!, saveURL: savePanel.url!) { (url, error) in
                                        print("File has been downloaded to : \(url!)")
                                    }
                                }
                            }
                        }
                        Button("Copy Image URL") {
                            let board = NSPasteboard.general
                            board.clearContents()
                            board.writeObjects([post.file as NSString])
                        }
                    } label: {
                    }
                    .menuStyle(BorderlessButtonMenuStyle())
                    .frame(width: 10, height: 10)
                    .padding(5)
                    .background(Color.accentColor.opacity(0.75))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(3)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 200)
        .padding(10)
        .background(Color.selectionColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))

    }
}
