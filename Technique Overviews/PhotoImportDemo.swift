//
//  PhotoImportDemo.swift
//  InstaFilter
//
//  Created by Purnaman Rai (College) on 15/01/2026.
//

/*
 # Why We Need Two Variabes?
 - You do NOT immediately get an Image
 - You first get a reference (PhotosPickerItem)
 - Then you asynchronously load the actual image data using loadTransferable()
 This design exists for performance and privacy reasons.
 
 
 # Why loadTransferable() Is Asynchronous?
 Photos can be:
 - Very large (panoramas, ProRAW, etc.)
 - Stored in iCloud (not on device yet)
 
 So Apple avoids freezing your UI by:
 - Giving you a lightweight reference (PhotosPickerItem)
 - Letting you request the data later, asynchronously
 */

import PhotosUI // Provides: PhotosPicker, PhotosPickerItem, Filtering options like .images, .videos
import SwiftUI

struct PhotoImportDemo: View {
    @State private var pickerItems = [PhotosPickerItem]() // A reference to the selected photo, NOT the photo itself (For Selection)
    @State private var selectedImages = [Image]() // Actual Image to display (For Display)
    // Initially, the user hasn’t picked anything yet, hence both are optional
    
    var body: some View {
        /*
         | Expression      | Meaning                                |
         | ----------------| ---------------------------------------|
         | .any(of: [...]) | OR — match if ANY condition is true    |
         | .all(of: [...]) | AND — match if ALL conditions are true |
         | .not(x)         | Exclude 'x'                            |
         */
        PhotosPicker("Select Images", selection: $pickerItems, maxSelectionCount: 3, matching: .all(of: [.images, .not(.screenshots)])) // Allow images, Exclude screenshots
            .onChange(of: pickerItems) {
                Task { // Enter background work (don't freeze the screen)
                    selectedImages.removeAll()
                    
                    for item in pickerItems {
                        if let loadedImage = try await item.loadTransferable(type: Image.self) {
                            selectedImages.append(loadedImage)
                        }
                    }
                }
            }
        
        /*
         
         We can also use custom label:
         
         PhotosPicker(selection: $pickerItems, maxSelectionCount: 3, matching: .images) {
            Label("Select Images", systemImage: "photo")
         }
         
         */
        
        ScrollView {
            ForEach(0..<selectedImages.count, id: \.self) { i in
                selectedImages[i]
                    .resizable() // Allows the image to: Change size, Respect layout constraints. Without this, the image uses its intrinsic size.
                    .scaledToFit() // Keeps: Aspect ratio, Entire image visible
            }
        }
    }
}

#Preview {
    PhotoImportDemo()
}
