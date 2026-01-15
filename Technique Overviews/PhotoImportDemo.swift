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
    @State private var pickerItem: PhotosPickerItem? // A reference to the selected photo, NOT the photo itself (For Selection)
    @State private var selectedImage: Image? // Actual Image to display (For Display)
    // Initially, the user hasn’t picked anything yet, hence both are optional
    
    var body: some View {
        PhotosPicker("Select An Image", selection: $pickerItem, matching: .images)
            .onChange(of: pickerItem) {
                Task { // Enter background work (don't freeze the screen)
                    selectedImage = try await pickerItem?.loadTransferable(type: Image.self) // “Please load the underlying data and convert it into a SwiftUI Image.”
                }
            }
        
        selectedImage?
            .resizable() // Allows the image to: Change size, Respect layout constraints. Without this, the image uses its intrinsic size.
            .scaledToFit() // Keeps: Aspect ratio, Entire image visible
    }
}

#Preview {
    PhotoImportDemo()
}
