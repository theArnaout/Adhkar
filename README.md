# Adhkar Watch App

A watchOS dhikr-counter designed to feel as authentic as using a masbaha/tasbeeh.  
Start with the post-prayer adhkar (“سبحان الله”, “الحمد لله”, “الله أكبر”), and soon choose from other collections like morning and evening adhkar.

## Features

- 
- Authentic swipe-and-tap UX with subtle haptics  
- Vector PDF assets for razor-sharp icons and bead graphics  

## Project Overview

- Digital dhikr with authentic subtle haptics
- 33-count cycle of post-prayer adhkar (“سبحان الله”, “الحمد لله”, “الله أكبر”) 
- Clean vector assets for crisp UI and graphics
- Extensible collections: post-prayer, morning, evening, and more

## Key Highlights

– **User Experience:** Custom swipe-and-tap counter, smooth animations, configurable haptic feedback  
– **Technical Challenge:** PDF-based asset pipeline, state-driven SwiftUI logic, WatchKit optimizations  
– **Design Aesthetic:** Minimalist interface, dark-mode–first

## Technology Stack

- **Language:** Swift 5, SwiftUI & WatchKit  
- **Assets:** Vector PDFs, SF Symbols  
- **CI/CD:** GitHub

## Architecture at a Glance

1. **State layer:** `@State` + `@AppStorage` for counter persistence  
2. **View layer:** SwiftUI views with custom gestures & haptics  
3. **Asset layer:** PDF bundles for resolution-independent graphics

## Roadmap
- ✓ Post-prayer adhkar  
- ◻ Morning & evening collections  
- ◻ Custom goal counts & reminders  
- ◻ Haptic intensity slider & accessibility tweaks
