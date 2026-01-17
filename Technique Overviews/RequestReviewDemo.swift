//
//  RequestReviewDemo.swift
//  InstaFilter
//
//  Created by Purnaman Rai (College) on 17/01/2026.
//

/*
 
 SwiftUI’s .requestReview environment value lets you ask the system to show an App Store review prompt.
 
 Key mindset shift:
 - You are not showing a review prompt.
 - You are requesting permission for iOS to maybe show one.
 
 Apple controls:
 - Whether it appears
 - When it appears
 - How often it appears
 - Whether the user even sees it
 
 
 Why Apple Designed It This Way?
 
 Apple wants reviews to:
 - Feel natural
 - Not be spammy
 - Appear at emotionally appropriate moments
 
 So they enforce:
 - Global limits per user per year
 - System-wide “disable review prompts” settings
 - Guidelines for deciding when to show or hide the UI
 */

import StoreKit
import SwiftUI

struct RequestReviewDemo: View {
    @Environment(\.requestReview) var requestReview
    @State private var appUsedCount = 0
    
    var body: some View {
        // DON'T:
        // Button("Leave Review") {
        //     requestReview()
        // }
        
        /*
         Problem: It might do nothing
         ------------------------------
         If:
         - User disabled review prompts
         - User already reviewed
         - System quota is exhausted
         
         Then:
         - Nothing happens
         - No feedback
         - Feels broken
         
         From the user’s perspective:
         - “I tapped a button and nothing happened.”
         
         That’s bad UX.
         Review requests should feel like a natural outcome, not a command.
         
         
         
         You don’t ask:
         - “Please review us now.”
         
         You instead say:
         - “The user just succeeded — this might be a good moment.”
         
         å
         
         Call requestReview() automatically, when:
         - The user has clearly benefited from your app
         - They are not frustrated
         - They just completed something meaningful
         
         Examples:
         - Completed a workout
         - Finished a level
         - Successfully exported data
         - Used a key feature several times
         
         */
        
        
        // DO:
        Button("Perform Some Task") {
            print("Task \(appUsedCount + 1) Complete ✓")
            appUsedCount += 1
            
            if appUsedCount == 3 {
                requestReview() // “Hey system, if appropriate, please consider showing a review prompt.”
            }
            
            /*
             Why this works:
             - The user understands your app’s value
             - The moment feels earned
             */
        }
    }
}

/*
 You are allowed to call requestReview():
 - Many times
 - At different points
 
 The system will:
 - Rate-limit automatically
 - Ignore extra calls
 - Never punish you for asking too often
 
 So your job is:
 - Call it at reasonable moments and forget about it.
 */

#Preview {
    RequestReviewDemo()
}
