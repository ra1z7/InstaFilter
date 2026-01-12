//
//  DifferentImageTypes.swift
//  InstaFilter
//
//  Created by Purnaman Rai (College) on 12/01/2026.
//

/*
 Image (SwiftUI):
    - What it is: A view, not image data.
    - Best use: When you just want to show a picture in your app’s layout.
    - You can’t easily access its pixel data; you can only tell it how to look (e.g., .resizable(), .scaledToFit()).
    - Not for processing, pixel manipulation or editing
 
 
 UIImage (UIKit):
    - What it is: A smart wrapper that manages image data. It handles things like device scale (Retina vs. non-Retina - @2x, @3x) and orientation (portrait vs. landscape).
    - It's a high-level object. It often "contains" a CGImage or CIImage inside it.
    - This is an extremely powerful image type capable of working with a variety of image types, including bitmaps (like PNG), vectors (like SVG), and even sequences that form an animation.
    - It is the standard image type for UIKit, and of the three it’s closest to SwiftUI’s Image type.
    - Use when: Working in UIKit, Loading images from assets, camera, or network.
 
 
 CGImage (Core Graphics):
    - What it is: A direct representation of the pixels (bitmap data). It knows exactly what color is at coordinate (x, y).
    - This is a simpler image type that is really just a two-dimensional array of pixels.
    - Purpose: Pixel-based drawing and rendering
    - Best use: When you need to do manual cropping, rotating, need direct pixel access or drawing into a specific context.
    - Best for low-level rendering
    - It is a C-based API. It’s very powerful and "close to the metal," but it doesn’t know about things like the device's screen scale or orientation—you have to handle those manually.
    - Not convenient for UI display on its own
 
 
 CIImage (Core Image):
    - This stores all the information required to produce an image but doesn’t actually turn that into pixels unless it’s asked to.
    - Lazy evaluation: If you chain five filters together, CIImage doesn't process them one by one. It waits until the very last second (when you try to display it) and then uses the GPU to calculate all the changes at once for maximum speed.
    - Apple calls CIImage “an image recipe” rather than an actual image.
    - Use when: Applying filters or image effects, Doing GPU-accelerated image processing
    - Must be rendered to CGImage or UIImage to display
 
 These image types (UIImage, CGImage and CIImage) are pure data, they hold image information – we can’t place them into a SwiftUI view hierarchy, but we can manipulate them freely then present the results in a SwiftUI Image.

 Usually, your workflow looks like this when using all of these Image types:
    - Load a UIImage from your assets.
    - Convert it to a CIImage to apply a "Sepia" filter.
    - Convert the result to a CGImage to "bake" the pixels.
    - Wrap it back into a UIImage or Image to show it to the user.
 
 Summary:
    - SwiftUI/UIKit is for the UI (Displaying).
    - Core Graphics (CG) is for the Drawing (Pixels).
    - Core Image (CI) is for the Effects (Filters).
 */
