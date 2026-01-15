//
//  ContentUnavailableViewDemo.swift
//  InstaFilter
//
//  Created by Purnaman Rai (College) on 14/01/2026.
//

import SwiftUI

// ContentUnavailableView is perfect for times your app relies on user information that hasn't been provided yet, such as when your user hasn't created any data, or if they are searching for something and there are no results.

struct ContentUnavailableViewDemo: View {
    var body: some View {
        ContentUnavailableView("No snippets", systemImage: "swift")
        
        
        // You can also add an extra line of description text below, specified as a Text view so you can add extra styling such as a custom font, or a custom color:
        ContentUnavailableView("No snippets", systemImage: "swift", description: Text("You don't have any saved snippets yet."))

        
        // If you want full control, you can provide individual views for the title and description, along with some buttons to display to help the user to get started:
        ContentUnavailableView {
            Label("No Snippets", systemImage: "swift")
        } description: {
            Text("You don't have any saved snippets yet.")
        } actions: {
            Button("Create Snippet") { }
                .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ContentUnavailableViewDemo()
}
