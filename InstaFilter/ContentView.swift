//
//  ContentView.swift
//  InstaFilter
//
//  Created by Purnaman Rai (College) on 09/01/2026.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import SwiftUI

struct ContentView: View {
    @State private var selectedImage: PhotosPickerItem?
    @State private var inputCIImage: CIImage?
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    @State private var showingFilterOptions = false
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone() // Type Erasure: “I only care that this is a CIFilter — nothing more.” Meaning, we lose access to .intensity, and type safety but gain ability to store any filter now
    let ciContext = CIContext() // A Core Image context is an object that’s responsible for rendering a CIImage to a CGImage (an object for converting the recipe for an image into an actual series of pixels we can work with).
    
    // Contexts are expensive to create, so if you intend to render many images it’s a good idea to create a context once and keep it alive and reuse many times.
    
    var currentFilterName: String {
        // dictionary[key] as? Type ?? defaultValue    - “Try to read key from the dictionary, cast it to Type, and if that fails or is nil, use defaultValue instead.”
        currentFilter.attributes[kCIAttributeFilterDisplayName] as? String ?? "Unknown Filter" // “Try to treat this value (which is Any?) as a String. If it’s not a String, return nil and use "Unknown Filter" instead of crashing.”
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                PhotosPicker(selection: $selectedImage) {
                    if let processedImage {
                        VStack {
                            Text(currentFilterName.uppercased())
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .clipShape(.capsule)
                                .glassEffect()
                            
                            processedImage
                                .resizable()
                                .scaledToFit()
                                .clipShape(.rect(cornerRadius: 10))
                        }
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
                
                if processedImage != nil { // Only show UI controls when an Image is loaded
                    VStack {
                        Text("INTENSITY")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        Slider(value: $filterIntensity)
                            .onChange(of: filterIntensity, applyFilter)
                        // Tip: If multiple views adjust the same value, or if it’s not quite so specific what is changing the value, then I’d add the modifier at the end of the view.
                    }
                    .padding(.vertical)
                    
                    HStack {
                        Button("Change Filter", systemImage: "camera.filters", action: changeFilter)
                            .confirmationDialog("Select a Filter", isPresented: $showingFilterOptions) {
                                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                                Button("Vignette") { setFilter(CIFilter.vignette()) }
                                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                                Button("Bloom") { setFilter(CIFilter.bloom()) }
                                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                                Button("Edges") { setFilter(CIFilter.edges()) }
                                Button("Motion Blur") { setFilter(CIFilter.motionBlur()) }
                            }
                        
                        Spacer()
                        
                        Button("Share", systemImage: "square.and.arrow.up") {}
                    }
                    .buttonStyle(.glass)
                }
            }
            .padding()
            .navigationTitle("InstaFilter")
        }
    }
    
    func loadImage() {
        Task {
            guard let imageAsData = try await selectedImage?.loadTransferable(type: Data.self) else { return }
            guard let uiImage = UIImage(data: imageAsData) else { return }
            inputCIImage = CIImage(image: uiImage)
            applyFilter()
        }
    }
    
    func applyFilter() {
        // Core Image filters have a dedicated inputImage property that lets us send in a CIImage for the filter to work with, but often this is thoroughly broken and will cause your app to crash – it’s much safer to use the filter’s setValue() method with the key kCIInputImageKey.
        currentFilter.setValue(inputCIImage, forKey: kCIInputImageKey)
        
        /*
         Core Image filters:
         - Do not all accept the same inputs
         - Use string keys, not properties
         
         When we assign CIFilter.sepiaTone() to a property, we get an object of the class CIFilter that conforms to protocol CISepiaTone.
         That protocol then exposes the .intensity parameter we’ve been using, but internally it will just map it to a call to setValue(_:forKey:).
         */
        
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) } // kCIInputIntensityKey is another Core Image constant value, and it has the same effect as setting the .intensity parameter of the sepia tone filter. Previously, this was all that the protocol was doing internally anyway, but it did provide valuable extra type safety.
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 100, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 50, forKey: kCIInputScaleKey) }
        
        guard let ciImage = currentFilter.outputImage else { return }
        guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    
    func changeFilter() {
        showingFilterOptions = true
    }
    
    func setFilter(_ newFilter: CIFilter) {
        currentFilter = newFilter
        applyFilter()
    }
}

#Preview {
    // Core Image is extremely fast on all iPhones, but it’s often extremely slow in the simulator.
    ContentView()
}
