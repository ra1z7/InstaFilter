//
//  OnChangeNotes.swift
//  InstaFilter
//
//  Created by Purnaman Rai (College) on 11/01/2026.
//

import SwiftUI

struct OnChangeNotes: View {
    @State private var blurAmount = 0.0 {
        didSet {
            print("Blur changed to \(blurAmount)")
        }
    }
    
    var body: some View {
        VStack {
            Text("Hello, World!")
                .blur(radius: blurAmount)
            
            Slider(value: $blurAmount, in: 0...20) // Binding changes (Sliders, Toggles, TextFields) bypass didSet.
            
            Button("Random Blur") {
                blurAmount = Double.random(in: 0...20) // Direct changes (Buttons) trigger didSet.
            }
            
            // Fix: Always use the .onChange(of:) modifier on your View if you need to react to changes in @State variables driven by UI controls.
        }
    }
}

/*
 DETAILED EXPLANATION
 
 Property wrappers have that name because they wrap our property inside another struct. What this means is that when we use @State to wrap a string, the actual type of property we end up with is a State<String>. Similarly, when we use @Environment and others we end up with a struct of type Environment that contains some other value inside it.
 
 Standard Rule: To change data inside a struct, the struct itself must change.
 The Consequence: If you have a didSet observer watching that struct, it fires because it sees the struct changing.
 
 However, the @State property wrapper is built differently. It uses a nonmutating set (A setter - assignment method - that updates an underlying value elsewhere without modifying the struct instance that called it).
   1. You assign a new number.
   2. The @State wrapper takes that number and sends it to a separate memory location managed by SwiftUI (outside of your View struct).
   3. The @State struct itself does not change. It remains the exact same instance in memory.
 
 This behavior is why your code fails when using a Slider (Binding).
   - When you use didSet: You are asking Swift to tell you when the blurAmount variable (the @State struct) changes.
   - When you use a Binding ($blurAmount): The Slider bypasses your variable entirely. It gets a direct reference to that separate memory location managed by SwiftUI. It updates the data there directly.
   - The Result: The data changes, but because of the "nonmutating" nature of the storage, your blurAmount variable (the struct) is never touched or replaced. Therefore, didSet never runs.
 
 So, when you write blurAmount = 5.0 inside a Button, you are using the Property Wrapper's Setter. Even though the setter is marked as nonmutating (meaning it doesn't change the State struct itself), Swift's compiler still treats a direct assignment to a property as a "set" event. Because you are explicitly calling blurAmount = ..., the Swift language logic says: "A value was assigned to this property, so I must run the didSet observer."
 
 Action  |  How it changes the value              |   Does didSet fire?
 --------------------------------------------------------------------------------------------------------------------------------------------------
 Button  |  blurAmount = 5.0 (Direct Assignment)  |   Yes — Swift sees the assignment and triggers the observer.
 Slider  |  $blurAmount (Direct Memory Update)    |   No — The assignment logic is bypassed; the "key" was used to change the data behind the scenes.
 
 This is exactly why the tutorial tells you to stop using didSet.
   - didSet only catches assignments (like the Button).
   - .onChange catches value changes, regardless of whether they happened via an assignment or via a background binding update (like the Slider).
 */

#Preview {
    OnChangeNotes()
}
