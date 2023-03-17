//
//  SwiftBooruApp.swift
//  SwiftBooru
//
//  Created by Ethan Woods on 16/03/2023.
//

import SwiftUI

struct MenuBarItem {
    let title: String
    let icon: String
    let myView: () -> AnyView
    
    init<V: View>(title: String, icon: String, myView: @escaping () -> V) {
        self.title = title
        self.icon = icon
        self.myView = { AnyView(myView()) }
    }
}

@main
struct SwiftbooruController: App {
    var body: some Scene {
        WindowGroup {
            
            let menuBarItems: [MenuBarItem] = [
                MenuBarItem(title: "Home", icon: "house") {
                    Text("Test A")
                },
                MenuBarItem(title: "Bookmarks", icon: "heart") {
                    Text("Test B")
                },
                MenuBarItem(title: "Discover", icon: "magnifyingglass") {
                    Text("Test C")
                },
            ]
            
            SwiftbooruCanvas(items: menuBarItems, defaultItem: 0)
        }
    }
}

struct SwiftbooruCanvas: View {
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    
    private let minWidth: CGFloat = 600
    private let minHeight: CGFloat = 400
    
    private let minColumnWidth: CGFloat = 150
    private let idealColumnWidth: CGFloat = 200
    private let maxColumnWidth: CGFloat = 300
    
    private let menuBarItems: [Int: MenuBarItem]
    private let defaultItem: Int
    
    init(items: [MenuBarItem], defaultItem: Int) {
        self.menuBarItems = items.indexedDictionary
        self.defaultItem = defaultItem
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(Array(self.menuBarItems.keys).sorted(by: <), id: \.self) { i in
                NavigationLink(destination: self.menuBarItems[i]?.myView() ?? AnyView(Text("Unknown"))) {
                    Label(self.menuBarItems[i]?.title ?? "Unknown", systemImage: self.menuBarItems[i]?.icon ?? "questionmark.square")
                }
            }
        } detail: {
            self.menuBarItems[self.defaultItem]?.myView() ?? AnyView(AnyView(Text("Unknown")))
        }
        .frame(minWidth: self.minWidth, minHeight: self.minHeight)
        .navigationSplitViewColumnWidth(min: self.minColumnWidth, ideal: self.idealColumnWidth, max: self.maxColumnWidth)
    }
}

extension Collection {
    var indexedDictionary: [Int: Element] {
        return Dictionary(uniqueKeysWithValues: enumerated().map{($0,$1)})
    }
}
