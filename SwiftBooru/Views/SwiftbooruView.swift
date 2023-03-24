//
//  SwiftbooruTest.swift
//  SwiftBooru
//
//  Created by Ethan Woods on 20/03/2023.
//

import Foundation
import SwiftUI
import URLImage
import URLImageStore

@main
struct SwiftbooruAppController: App {
    var body: some Scene {
        WindowGroup {
            SwiftbooruCanvasView(
                name: "Swiftbooru",
                description: "To get started, browse images in the discovery tab.",
                items: [
//                    "house": AnyView(Text("Test A")),
                    "heart": AnyView(BooksmarksView()),
                    "magnifyingglass": AnyView(SearchView())
                ],
                defaultView: "magnifyingglass"
            )
            .environment(\.urlImageService, URLImageService(fileStore: nil, inMemoryStore: URLImageInMemoryStore()))
            
        }
    }
    
}

struct SwiftbooruCanvasView: View {
    @State var selectedIcon: String
    @State var showPopup: Bool = false
    let viewSwitch: [String:AnyView]
    private let projectName: String
    private let projectDesc: String
    
    init(name: String, description: String, items: [String:AnyView], defaultView: String) {
        self.viewSwitch = items
        self.projectName = name
        self.projectDesc = description
        self.selectedIcon = defaultView
    }
    
    var body: some View {
        viewSwitch[selectedIcon]
        .toolbar() {
            ForEach(Array(self.viewSwitch.keys).sorted(by: >), id: \.self) { icon in
                SwiftbooruSwitcher(icon: icon, selectedIcon: $selectedIcon)
            }
        }
        .sheet(isPresented: $showPopup) {
            PopupView(projectName: self.projectName, projectDesc: self.projectDesc)
        }
        .onAppear {
            if !(UserDefaults.standard.bool(forKey: "hasLaunchedBefore")) {
                UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                showPopup = true
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

struct PopupView: View {
   @Environment(\.presentationMode) var presentationMode

   let projectName: String
   let projectDesc: String
   
   var body: some View {
       VStack {
           Text("Welcome to \(projectName)")
               .font(.title)
               .padding(.top, 10)
           Text(projectDesc)
               .font(.subheadline)
           Spacer()
           Button("Close") {
               presentationMode.wrappedValue.dismiss()
           }
           .buttonStyle(.borderless)
       }
       .background(
           Image("moonlight")
               .resizable()
               .scaledToFill()
               .offset(y:80)
       )
       .padding(.horizontal, 20)
       .padding(.vertical, 20)
       .frame(width: 400, height: 200)
       .cornerRadius(10)
       .shadow(radius: 10)
   }
}
