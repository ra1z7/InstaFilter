//
//  ApplyingFilters.swift
//  InstaFilter
//
//  Created by Purnaman Rai (College) on 13/01/2026.
//

import CoreImage // Think of Core Image not as a paint set (it's not for drawing lines or shapes), but as a photo lab.
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ApplyingFilters: View {
    @State private var image: Image?
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage) // applied this modifier to VStack, since image starts as nil, it doesn't exist on screen yet, so it can't "appear" to trigger the function.
    }
    
    func loadImage() {
        // SwiftUI is too simple to "read" raw data for filtering, so we use UIImage to initially load the picture from your Asset catalog.
        let inputImage = UIImage(resource: .example)
        let beginImage = CIImage(image: inputImage) // This is not a picture yet. It is a cooking recipe. It contains the data ("here are the pixels") and the instructions ("apply sepia tone"). It doesn't actually process the image until you force it to.
        
        let context = CIContext() // This is the Engine or the Chef. The filter below describes what to do, but the Context is the heavy-lifter that actually talks to the GPU to calculate the math. Because converting a "recipe" (CIImage) into actual pixels (CGImage) is computationally expensive. The CIContext manages this work efficiently.
        let currentFilter = CIFilter.crystallize() // we can change filter between sepiaTone(), crystallize(), pixellate() freely
        currentFilter.inputImage = beginImage
        
        // Using the modern API is great if you know exactly which filter you are using. You can type currentFilter. and Xcode will autocomplete the correct properties for you.
        
        // However, the goal of this specific project is to let the user pick a filter. If the user picks "Sepia", we need to set intensity. If they pick "Twirl", we need to set radius. Writing a massive if/else statement for every possible filter would be a nightmare. This brings us to the "Old" API:
        
        let filterAmount = 1.0
        
        // The "Old" API treats every filter like a dictionary (or a hash map). Instead of properties, it uses Keys (Strings):
        let filterInputKeys = currentFilter.inputKeys // Ask the filter for a list of supported settings
        
        if filterInputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterAmount, forKey: kCIInputIntensityKey) } // "Hey Filter, do you have an 'Intensity' knob? If yes, set it to amount."
        // If the current filter is Sepia, this runs.
        // If the current filter is Twirl, this is ignored (Twirls don't have intensity).
        
        if filterInputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterAmount * 50, forKey: kCIInputScaleKey) }
        if filterInputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterAmount * 100, forKey: kCIInputRadiusKey) }
        
        // The code automatically figures out which values apply to the current filter and ignores the rest.
        
        guard let outputImage = currentFilter.outputImage else { return } // We ask the filter for its output. This is still a CIImage (a recipe).
        
        // Once the "Recipe" (CIImage) is cooked, the result is just data. We need to turn that data into actual pixels that a screen can render:
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return } // .extent is a fancy way of saying "the entire width and height of the image."
        
        let uiImage = UIImage(cgImage: cgImage)
        image = Image(uiImage: uiImage)
    }
}

#Preview {
    ApplyingFilters()
}
