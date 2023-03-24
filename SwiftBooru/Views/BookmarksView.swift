//
//  BookmarksView.swift
//  SwiftBooru
//
//  Created by Ethan Woods on 18/03/2023.
//

import Foundation
import SwiftUI


struct BooksmarksView: View {
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    @State private var currentTags: [String:Int] = [:]
    @State private var currentPosts: [BooruPost] = []
    @State private var selectedTags: [String] = []
    @State private var searchText: String = ""
    
    private let minColumnWidth: CGFloat = 150
    private let idealColumnWidth: CGFloat = 200
    private let maxColumnWidth: CGFloat = 300
    
    var filteredTags: [String] {
        return self.currentTags.keys.filter { searchText.isEmpty ? true : $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationSplitView {
            List(filteredTags.sorted(by: <), id: \.self) { i in
                TagButton(tag: i, count: currentTags[i] ?? 0, selectedTags: $selectedTags, currentPosts: $currentPosts)
            }
        } detail: {
            DetailBookmarkView(currentPosts: $currentPosts, selectedTags: $selectedTags)
        }
        .navigationSplitViewColumnWidth(min: minColumnWidth, ideal: idealColumnWidth, max: maxColumnWidth)
        .onAppear {
            currentTags = BookmarkManager(identifier: "Bookmarks").getTags()
        }
        .searchable(text: $searchText, placement: .toolbar)
    }
}

struct TagButton: View {
    let tag: String
    let count: Int
    @Binding var selectedTags: [String]
    @Binding var currentPosts: [BooruPost]
    @Environment(\.colorScheme) var colorScheme
    
    private func toggleSelection() {
        if let index = selectedTags.firstIndex(of: tag) {
            selectedTags.remove(at: index)
        } else {
            selectedTags.append(tag)
        }
    }
    
    private func isSelected() -> Bool {
        return selectedTags.contains(tag)
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                toggleSelection()
                if !(selectedTags.isEmpty) {
                    currentPosts = BookmarkManager(identifier: "Bookmarks").getMatchingPosts(tags: selectedTags)
                } else {
                    currentPosts = []
                }
            }
        }) {
            HStack {
                Text(tag)
                Text(String(count))
                    .font(.caption)
            }
            .foregroundColor(isSelected() ? .white : colorScheme == .dark ? .white : .black)
            .padding(Swiftbooru.defaultPadding3)
            .background(isSelected() ? .accentColor : colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.2))
            .cornerRadius(Swiftbooru.defaultCornerRadius3)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DetailBookmarkView: View {
    @Binding var currentPosts: [BooruPost]
    @Binding var selectedTags: [String]
    @State private var currentImage: BooruPost? = nil
    @State private var isShowingImage: Bool = false
    @State private var isShowingData: Bool = false
    @State private var currentPage = 1
    @State private var isShowingImages: Bool = false
    
    private let suggesitonLimit: Int = 10
    private let imageLimit: Int = 19
    private let itemsPerRow: Int = 4
    private let gridSpacing: CGFloat = 10
    
    func getPosts() -> [BooruPost] {
        var trueCurrentPosts: [BooruPost] = []
        for (i, post) in currentPosts.enumerated() {
            if (currentPage*imageLimit) < i {
                return trueCurrentPosts
            } else {
                trueCurrentPosts.append(post)
            }
        }
        return trueCurrentPosts
    }
    
    func addPost() {
        currentPage += 1
    }
    
    var body: some View {
        if currentPosts.isEmpty {
            if (BookmarkManager(identifier: "Bookmarks").getTags().isEmpty) {
                Text("No Tags Found")
                    .font(.largeTitle)
                Text("You can bookmark new images from the discovery tab.")
                    .font(.subheadline)
            } else {
                if selectedTags.isEmpty {
                    Text("No Tags Selected")
                        .font(.largeTitle)
                    Text("Try selecting some from the left column.")
                        .font(.subheadline)
                } else {
                    Text("No Posts found")
                        .font(.largeTitle)
                    Text("Try removing a few selected tags.")
                        .font(.subheadline)
                }
            }
        } else {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: gridSpacing), count: itemsPerRow), spacing: gridSpacing) {
                        ForEach(getPosts()) { post in
                            PostView(post: post, isShowingTag: $isShowingData, currentPost: $currentImage)
                                .onTapGesture {
                                     currentImage = post
                                     isShowingImage = true
                                 }
                        }
                        .onAppear() {
                            isShowingImages = true
                        }
                        .onDisappear() {
                            isShowingImages = false
                        }
                    }
                    .padding(10)
                }
                .onChange(of: isShowingImages) { isState in
                    currentPage = 1
                }
                
                VStack {
                    Spacer()
                    Clicker(info: "Load More...", function: addPost)
                    .padding(.bottom, 15)
                }
            }
            .overlay(
                ZStack {
                    if isShowingImage, let currentImage = currentImage {
                        Color.overlayColor
                            .ignoresSafeArea()
                            .onTapGesture {
                                isShowingImage = false
                            }
                        VStack {
                            currentImage.getFile()
                                .padding(30)
                        }
                    } else {
                        if isShowingData, let currentImage = currentImage {
                            Color.overlayColor
                                .ignoresSafeArea()
                                .onTapGesture {
                                    isShowingData = false
                                }
                            HStack {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: CGFloat(currentImage.getTags().count / 6)), count: 6), spacing: 3) {
                                    ForEach(currentImage.getTags(), id: \.self) { tag in
                                        Text(tag)
                                            .foregroundColor(.secondary)
                                            .padding(4)
                                            .background(Color.highlightColor.opacity(0.75))
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                            .padding(5)
                                    }
                                }
                                .background(Color.backgroundColor)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.horizontal, 40)
                                .shadow(radius: 2)
                                
                                VStack(alignment: .leading) {
                                    Text("Image: \(currentImage.image)")
                                        .foregroundColor(.secondary)
                                        .padding(4)
                                        .background(Color.highlightColor.opacity(0.75))
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .padding(5)
                                    Text("File URL: \(currentImage.file)")
                                        .foregroundColor(.secondary)
                                        .padding(4)
                                        .background(Color.highlightColor.opacity(0.75))
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .padding(5)
                                    Text("ID: \(currentImage.id)")
                                        .foregroundColor(.secondary)
                                        .padding(4)
                                        .background(Color.highlightColor.opacity(0.75))
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .padding(5)
                                    Text("Type: \'\(currentImage.getType().description)\'")
                                        .foregroundColor(.secondary)
                                        .padding(4)
                                        .background(Color.highlightColor.opacity(0.75))
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .padding(5)
                                    Text("Preview URL: \(currentImage.preview)")
                                        .foregroundColor(.secondary)
                                        .padding(4)
                                        .background(Color.highlightColor.opacity(0.75))
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .padding(5)
                                    Text("Rating: \(currentImage.rating.description)")
                                        .foregroundColor(.secondary)
                                        .padding(4)
                                        .background(Color.highlightColor.opacity(0.75))
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .padding(5)
                                }
                                .background(Color.backgroundColor)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.horizontal, 40)
                                .shadow(radius: 2)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
        }
    }
}
