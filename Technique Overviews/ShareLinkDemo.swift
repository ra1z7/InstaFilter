//
//  ShareLinkDemo.swift
//  InstaFilter
//
//  Created by Purnaman Rai (College) on 16/01/2026.
//

import SwiftUI

/*
 
 ShareLink's Job: “Take some data from my app and let the system share it.”
 
 The system:
 - Decides which apps can receive it
 - Builds the share sheet
 - Handles permissions, previews, and routing
 You only describe WHAT you want to share — not HOW.
 
 */

struct ShareLinkDemo: View {
    let urlToShare = URL(string: "https://www.hackingwithswift.com")!
    let imageToShare = Image(.example)
    
    var body: some View {
        // Default Label
        ShareLink(item: urlToShare)
        /*
         What happens at runtime:
         1. User taps Share
         2. iOS inspects the item type (URL)
         3. iOS finds apps that can handle URLs
         4. Share sheet appears
         5. User chooses an app
         
         SwiftUI never needs to know which app was chosen.
         */
        
        
        
        // Custom Label
        ShareLink(item: urlToShare) {
            Label("Learn Swift", systemImage: "swift")
        }
        
        
        
        ShareLink(
            item: urlToShare,
            subject: Text("Learn Swift"),
            message: Text("100 Days of SwiftUI")
        )
        /*
         Some share targets support:
         - Subject (e.g. Mail)
         - Message body (e.g. Messages)
         
         Others:
         - Ignore both
         - Or only use one
         
         This inconsistency is expected and normal.
         */
        
        
        
        ShareLink(item: imageToShare, preview: SharePreview("A Wallpaper", image: imageToShare))
        
        /*
         When you share:
         - Images
         - Custom data
         - Non-obvious content
         
         The receiving app needs:
         - A preview
         - A description
         
         Even images sometimes need explicit previews.
         
         Why is this needed even for images?
         - ShareLink supports custom transferable data
         - The system can’t always infer:
         -- A good title
         -- A good thumbnail
         - Explicit previews avoid ambiguity.
         
         This is slightly annoying — but predictable.
         */
    }
}

#Preview {
    ShareLinkDemo()
}
