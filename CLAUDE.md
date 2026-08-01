# Project Overview: MyVoice-iOS
MyVoice is a UIKit-first iOS text-to-speech app (with a few SwiftUI screens) built with **MVVM + RxSwift**, **CocoaPods** for dependencies, and **CoreData** for phrase persistence. Always open `MyVoice.xcworkspace` (never `MyVoice.xcodeproj`) because of CocoaPods.
- **Minimum iOS:** 15.0
- **Latest OS Features:** Supports iOS 26+ "Liquid Glass" UI.

# Architecture & Coding Rules (CRITICAL)
This is a transitional codebase. We are moving from UIKit/RxSwift to SwiftUI/async-await. You must strictly obey these boundaries based on what you are modifying:

**For NEW Screens, Components, and Logic:**
- **UI:** Use SwiftUI exclusively. Do not create new `.xib` or storyboard files.
- **Concurrency:** Use modern Swift `async/await`.
- **Reactivity:** Use standard Combine or SwiftUI state (`@State`, `@Observable`, etc.). Do not use RxSwift for new features.

**For EXISTING/LEGACY Screens and Logic:**
- **UI:** Mos of the existing screens use UIKit and `.xib` files. Leave them as-is. Do not rewrite UIKit views to SwiftUI unless explicitly asked.
- **Reactivity:** Existing logic uses mostly RxSwift. Continue using RxSwift when patching or extending these specific legacy components.

# Project Structure

```
MyVoice/                          # App source
├── AppDelegate.swift
├── SceneDelegate.swift
├── Base/                         # BaseViewController / BaseViewModel — parents for all screens
├── Screens/                      # One folder per feature screen
│   ├── Main/                     # Main TTS screen (UIKit + xib)
│   ├── Settings/                 # Settings screen (UIKit + xib)
│   ├── Display/                  # Full-screen display of spoken text (UIKit, no xib)
│   ├── LanguagePicker/           # Voice/language picker (UIKit + xib)
│   ├── Help/                     # Help content (SwiftUI)
│   └── PersonalVoiceBottomSheet/ # iOS 17+ Personal Voice onboarding (SwiftUI)
├── CustomViews/                  # Reusable UI components
│   ├── Cells/                    # VoiceCell, SwitchCell, SliderCell, QuickPhraseCell
│   ├── Buttons/                  # ActionButton, TouchHandlerButton
│   ├── ScrollViews/              # CustomScrollView
│   ├── TableViews/               # ContentSizedTableView
│   ├── TextViews/                # MainTextView
│   ├── NavigationControllers/    # DefaultNavigationController
│   └── Views/                    # HeaderView, ToolbarInputAccessoryView, MainTextViewBackgroundView
├── Services/                     # Business logic layer
│   ├── TextToSpeechService.swift
│   ├── PersonalVoiceService.swift
│   ├── PhraseDatabaseService.swift
│   ├── DatabaseService.swift
│   └── UserDefaultsService.swift
├── CoreData/                     # Phrase entity + Model.xcdatamodeld
├── Models/                       # Plain data models (QuickPhraseModel, SettingModel)
├── Enums/                        # Type-safe constants (Colors, Fonts, Nib, System, SliderDataType, …)
│   └── Errors/                   # Typed error enums
├── Extensions/                   # UIKit / Foundation / AVFoundation extensions
│   └── Modifiers/                # SwiftUI ButtonStyles (ScalableButtonStyle)
├── Helpers/                      # OrientationManager
├── Base.lproj/                   # LaunchScreen.storyboard
├── pl.lproj/                     # Polish LaunchScreen strings
└── SupportingFiles/
    ├── Info.plist
    ├── Fonts/                    # Poppins family (Regular / Medium / SemiBold / Bold)
    ├── Translations/             # Localizable.xcstrings, InfoPlist.xcstrings (String Catalogs)
    └── Resources/
        ├── Assets.xcassets       # Images, launch logo, placeholders
        ├── Colors.xcassets       # Named color sets (Blue/Purple/Orange/Red — Main/Light/Dark variants)
        └── AppIcon.icon          # iOS 18+ Icon Composer app icon

MyVoice.xcworkspace/              # Open this in Xcode
MyVoice.xcodeproj/                # Do not open directly
Podfile                           # RxSwift, RxCocoa, RxDataSources
```

## Conventions
- **Screens**: each folder pairs `<Name>ViewController.swift` + `<Name>ViewModel.swift` (+ optional `.xib`). SwiftUI screens use `<Name>View.swift` + `<Name>ViewModel.swift`.
- **Localization**: managed via **String Catalogs** (`Localizable.xcstrings`, `InfoPlist.xcstrings`) — do not add legacy `.strings` files. Supported: English (base) + Polish.
- **Colors & fonts**: always reference via `Enums/Colors.swift` and `Enums/Fonts.swift`, never raw asset names or literal font names.
- **CoreData**: the single entity is `Phrase`. Access goes through `PhraseDatabaseService` / `DatabaseService`, not the context directly.

## Ignored — do not search or edit
`Pods/`, `.git/`, `xcuserdata/`, `DerivedData/`, `*.xcuserstate`, `.DS_Store`, `Podfile.lock` (regenerated on `pod install`).

# Dependencies & Build
- We use **CocoaPods** (e.g., for RxSwift). 
- If you modify the Podfile, run `pod install` (do NOT use Swift Package Manager unless explicitly instructed to migrate a dependency).
- Always ensure the project compiles cleanly via standard `xcodebuild -workspace MyVoice.xcworkspace -scheme MyVoice` after making structural changes.

# Feature Constraints & SDKs
- **Text-to-Speech:** Rely exclusively on native Apple APIs (`AVFoundation`, `AVSpeechSynthesizer`).
- **Theming:** Every UI component must support both Light and Dark Mode. 

# Agent Workflow
1. When asked to fix a bug in an old feature, check if it's UIKit/RxSwift and respect that style.
2. When asked to create a new feature, immediately scaffold it using SwiftUI and `async/await`.
3. If you need to bridge SwiftUI into the legacy UIKit code, consider using `UIHostingController`.
