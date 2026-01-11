//
//  ConfirmationDialogDemo.swift
//  InstaFilter
//
//  Created by Purnaman Rai (College) on 11/01/2026.
//

import SwiftUI

// confirmationDialog() is an alternative to alert() that lets us add many buttons.

struct ConfirmationDialogDemo: View {
    @State private var showingConfirmation = false
    @State private var backgroundColor = Color.white
    
    var body: some View {
        Button("Change Background Color") {
            showingConfirmation.toggle()
        }
        .frame(width: 300, height: 200)
        .background(backgroundColor)
        .confirmationDialog("Change Background", isPresented: $showingConfirmation) {
            Button("Red") { backgroundColor = .red }
            Button("Blue") { backgroundColor = .blue }
            Button("Green") { backgroundColor = .green }
        } message: {
            Text("Change Background Color To:")
        }
    }
}

#Preview {
    ConfirmationDialogDemo()
}
