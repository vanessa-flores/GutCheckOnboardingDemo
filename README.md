# GutCheck Onboarding Demo

A demonstration of the onboarding flow for GutCheck, an iOS health tracking app focused on gut-hormone connections.

## What This Demonstrates

- **SwiftUI animations** - Custom fade and slide transitions
- **Multi-screen flows** - Progressive onboarding with skip/exit patterns
- **Form handling** - Multi-select checkboxes with dynamic text input
- **UX patterns** - Optional email collection, always-enabled buttons, user agency

## Features

- 6-screen onboarding flow with custom animations
- Interactive symptom collection screen
- Progressive disclosure pattern
- Accessible navigation (exit at any point)

## Technical Highlights

- Pure SwiftUI implementation
- Custom transition animations (fade + slide)
- Sequenced animations on welcome screen
- Form validation and state management
- Clean architecture separation

## Running the Project

1. Clone the repository
2. Open `GutCheckOnboardingDemo.xcodeproj` in Xcode 15+
3. Select a simulator or device
4. Build and run (⌘R)

## Project Structure
```
GutCheckOnboardingDemo/
├── Views/
│   ├── Onboarding/
│   │   ├── WelcomeView.swift
│   │   ├── OnboardingScreen1.swift
│   │   └── ...
│   └── Components/
├── Models/
└── ViewModels/
```

## Notes

This is a UI prototype demonstrating the onboarding experience. It uses mock data and does not include:
- Backend integration
- Data persistence
- Production authentication
- Full app functionality

For questions or feedback, feel free to open an issue!

## License

MIT License - This is a portfolio/demo project
