//
//  ContentView.swift
//  InstaFilter
//
//  Created by Purnaman Rai (College) on 09/01/2026.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    @State private var selectedImage: PhotosPickerItem?
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                PhotosPicker(selection: $selectedImage) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 10))
                    } else {
                        ContentUnavailableView(
                            "No Photo Selected",
                            systemImage: "photo.badge.plus",
                            description: Text("Tap to import a Photo")
                        )
                    }
                }
                .buttonStyle(.plain) // to disable blue coloring
                .onChange(of: selectedImage, loadImage)
                
                Spacer()
                
                VStack {
                    Text("INTENSITY")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Slider(value: $filterIntensity)
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change Filter", systemImage: "camera.filters") {}
                    Spacer()
                    Button("Share", systemImage: "square.and.arrow.up") {}
                }
                .buttonStyle(.glass)
            }
            .padding()
            .navigationTitle("InstaFilter")
        }
    }
    
    func loadImage() {
        Task {
            processedImage = try await selectedImage?.loadTransferable(type: Image.self)
        }
    }
}

#Preview {
    ContentView()
}
