# Repository Guidelines

## Project Structure & Module Organization
- `SleepSoundsAppApp.swift` declares the SwiftUI entry point and application lifecycle. Extend it when adding new scenes or global services.
- `ContentView.swift` houses the primary sleep-sound interface. Prefer extracting reusable views or view models into adjacent files inside `SleepSoundsApp/` to keep scope clear.
- `Assets.xcassets` contains color palettes and artwork. Add imagery or icons here and name assets with descriptive `PascalCase` identifiers (e.g., `MoonGlow`).
- `SleepSoundsApp.xcodeproj` tracks schemes and build settings; commit scheme changes when they affect other contributors.

## Build, Test, and Development Commands
- `xed SleepSoundsApp.xcodeproj` (macOS) opens the project in Xcode for interactive development.
- `xcodebuild -scheme SleepSoundsApp -destination 'platform=iOS Simulator,name=iPhone 15' build` performs a clean CLI build; adjust the destination to match your simulator.
- `xcodebuild -scheme SleepSoundsApp -destination 'platform=iOS Simulator,name=iPhone 15' test` executes unit/UI tests once they are added.

## Coding Style & Naming Conventions
- Follow Swift API Design Guidelines: `PascalCase` for types/protocols, `camelCase` for functions, properties, and bindings.
- Use 4-space indentation and keep line length under ~120 characters; leverage Xcode’s `Editor ▸ Structure ▸ Re-Indent` before committing.
- Prefer `struct` over `class` for view models unless reference semantics are required. Group modifiers logically and annotate complex view builders with brief comments.

## Testing Guidelines
- House tests in a `SleepSoundsAppTests/` target mirroring the source structure (e.g., `SleepSoundsAppTests/ContentViewTests.swift`).
- Name tests with intent-revealing prefixes such as `testLoadsDefaultPreset()` or `testVolumeSliderPersistsValue()`.
- Aim to cover new view model logic with unit tests and verify critical UI flows using Xcode UI tests. Run the `xcodebuild … test` command before opening a pull request.

## Commit & Pull Request Guidelines
- Write commit summaries in the imperative mood with a concise scope, e.g., `Add rain sound preset` or `Fix playback loop timing`; include a short body when context is non-obvious.
- Keep pull requests focused. Provide a summary of changes, testing steps (simulator & device), and screenshots or screen recordings for UI updates.
- Link issues or task references in the PR description and call out any follow-up work so reviewers can plan accordingly.

## Assets & Configuration Tips
- Ensure audio or imagery additions are licensed for distribution. Store large binary assets outside of git and reference them with download steps if necessary.
- When introducing configuration values (e.g., volume thresholds), centralize them in a dedicated Swift file (`Config.swift`) to keep tuning straightforward.
