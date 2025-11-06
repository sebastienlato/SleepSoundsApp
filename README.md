# Sleep Sounds App

Sleep Sounds App is a SwiftUI iOS application that helps users relax and fall asleep with a curated catalog of ambient soundscapes. The interface highlights large, accessible controls, color-coded cards, and tactile feedback to make sound mixing feel effortless.

## Features
- Six looping ambient sound presets (rain, ocean, forest, fire, wind, white noise) bundled as high-quality audio assets.
- Individual play/pause controls, per-sound volume sliders, and haptic feedback on interaction.
- Background audio playback so sounds continue while the device is locked or the app is in the background.
- Configurable sleep timer with presets, hour/minute picker, and active countdown banner to automatically stop playback.
- Lightweight architecture with feature, service, and model folders for maintainability.

## Getting Started
1. Open the project in Xcode: `xed SleepSoundsApp.xcodeproj`.
2. Select the *SleepSoundsApp* scheme, choose an iOS simulator (or connected device), and press **Run**.
3. To test from the command line, run `xcodebuild -scheme SleepSoundsApp -destination 'platform=iOS Simulator,name=iPhone 15' build`.

## Project Layout
```
SleepSoundsApp/
├─ App/                      # SwiftUI entry point
├─ Features/
│  └─ Soundboard/            # UI for sound cards and sleep timer
├─ Services/
│  ├─ Audio/                 # Audio playback manager
│  └─ Timer/                 # Sleep timer state and countdown logic
├─ Models/                   # Data models (SleepSound catalog)
├─ Assets.xcassets/          # App icons, colors, and audio bundles
└─ Config/                   # Info.plist configuration
```

## Contributing Notes
- Follow Swift API Design Guidelines (`camelCase` for properties/methods, `PascalCase` for types).
- Keep indentation at 4 spaces and rely on Xcode’s re-indent tools before committing.
- Include screenshots or recordings in pull requests when modifying UI and document manual test steps.

## License
This project currently has no explicit license. Contact the repository owner before distributing or reusing the code.
