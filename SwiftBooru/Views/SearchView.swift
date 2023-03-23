//
//  SearchView.swift
//  SwiftBooru
//
//  Created by Ethan Woods on 21/03/2023.
//

import Foundation
import SwiftUI

struct SearchView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchResult: [BooruPost] = []
    @State private var currentTokens: [BooruTag] = []
    @State private var suggestedTokens: [BooruTag] = []
    @State private var currentImage: BooruPost? = nil
    @State private var isShowingImage: Bool = false
    @State private var searchText: String = ""
    @State private var currentSearch: String = ""
    @State private var currentPage: Int = 0
    @State private var isNSFWEnabled: Bool = false
    
    private let suggestionLimit: Int = 10
    private let imageLimit: Int = 20
    private let itemsPerRow: Int = 4
    private let gridSpacing: CGFloat = 10
    
    func filterSearch() {
        if searchText.contains(" ") {
            searchText = searchText.replacingOccurrences(of: " ", with: "")
            if !suggestedTokens.isEmpty && suggestedTokens[0].id == searchText {
                currentTokens.append(suggestedTokens[0])
                searchText = ""
            }
        } else {
            setSimilar()
        }
    }
    
    func setSimilar() {
        if isNSFWEnabled {
            if let url = Swiftbooru.getURL(kind: .tagsearchGelbooru, term: searchText, limit: String(suggestionLimit)) {
                fetchJSON(url: url, completion: { (result: Result<[GelbooruTag], Error>) in
                    switch result {
                    case .success(let tags):
                        suggestedTokens = []
                        suggestedTokens = tags.map { BooruTag(tag: $0) }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
            }
        } else {
            if let url = Swiftbooru.getURL(kind: .tagsearchSafebooru, term: searchText) {
                fetchJSON(url: url, completion: { (result: Result<[SafebooruTag], Error>) in
                    switch result {
                    case .success(let tags):
                        suggestedTokens = []
                        suggestedTokens = tags.map { BooruTag(tag: $0) }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
            }
        }
    }
    
    func submitSearch() {
        currentSearch = currentTokens.map { $0.id }.joined(separator: " ")
        if isNSFWEnabled {
            if let url = Swiftbooru.getURL(kind: .imagesearchGelbooru, term: currentSearch, limit: String(imageLimit), page: "0") {
                fetchJSON(url: url, completion: { (result: Result<GelbooruSearch, Error>) in
                    switch result {
                    case .success(let posts):
                        searchResult = posts.post.map { BooruPost(post:$0) }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
            }
        } else {
            if let url = Swiftbooru.getURL(kind: .imagesearchSafebooru, term: currentSearch, limit: String(imageLimit), page: "0") {
                fetchJSON(url: url, completion: { (result: Result<SafebooruPosts, Error>) in
                    switch result {
                    case .success(let posts):
                        searchResult = posts.map { BooruPost(post:$0) }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
            }
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: gridSpacing), count: itemsPerRow), spacing: gridSpacing) {
                ForEach(searchResult) { result in
                    PostView(post: result)
                }
            }
            .padding(10)
        }
        .searchable(text: $searchText, tokens: $currentTokens, suggestedTokens: $suggestedTokens) { token in
            Text(token.id)
        }
        .onChange(of: searchText) { _ in
            filterSearch()
        }
        .onSubmit(of: .search) {
            submitSearch()
            currentPage = 0
        }
        .toolbar() {
            ToolbarItem(placement: .navigation) {
                Toggler(info: "NSFW", isEnabled: $isNSFWEnabled)
            }
        }
    }
}

struct Toggler: View {
    let info: String
    @Binding var isEnabled: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                isEnabled.toggle()
            }
        }) {
            Text(info)
                .foregroundColor(isEnabled ? .white : colorScheme == .dark ? .white : .black)
                .padding(5)
                .background(isEnabled ? .accentColor : colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.2))
                .cornerRadius(5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
