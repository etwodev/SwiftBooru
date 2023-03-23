//
//  SwiftbooruTest.swift
//  SwiftBooru
//
//  Created by Ethan Woods on 20/03/2023.
//

import Foundation
import SwiftUI

@main
struct SwiftbooruAppController: App {
    
    var body: some Scene {
        WindowGroup {
            SwiftbooruCanvasView(
                viewSwitch: [
                    "house": AnyView(Text("Test A")),
                    "heart": AnyView(BooksmarksView()),
                    "magnifyingglass": AnyView(Text("Test C"))
                ])
        }
    }
    
}

struct SwiftbooruCanvasView: View {
    @State var selectedIcon: String = ""
    let viewSwitch: [String:AnyView]
    
    var body: some View {
        viewSwitch[selectedIcon]
        .toolbar() {
            ForEach(Array(self.viewSwitch.keys).sorted(by: >), id: \.self) { icon in
                SwiftbooruSwitcher(icon: icon, selectedIcon: $selectedIcon)
            }
        }
    }
}


struct SwiftbooruSwitcher: View {
    let icon: String
    @Binding var selectedIcon: String
    @Environment(\.colorScheme) var colorScheme
    
    private func isSelected() -> Bool {
        return selectedIcon == icon
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedIcon = icon
            }
        }) {
            Image(systemName: icon)
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(isSelected() ? .white : colorScheme == .dark ? .white : .black)
                .padding(5)
                .background(isSelected() ? .accentColor : colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.2))
                .cornerRadius(5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
