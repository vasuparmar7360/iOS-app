# CodeX Nebula 🌌💻

> **CodeX Nebula** is a premium, futuristic, cyberpunk-themed gamified programming learning platform built entirely natively for iOS. It combines the thrill of RPG-style progression with rigorous software engineering education, empowering users to learn coding through an immersive, visually stunning experience.

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Framework-blue.svg)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-lightgrey.svg)
![Platform](https://img.shields.io/badge/Platform-iOS_16.0+-lightgrey.svg)
![Status](https://img.shields.io/badge/Status-Production_Ready-success.svg)

---

## 🌟 Key Features

### 🎮 Gamified Progression System
- **Level Up & Earn XP**: Every problem solved and battle won grants Experience Points (XP).
- **Dynamic Leaderboards**: Climb the global ranks and showcase your skills as a top-tier developer.
- **Achievements & Badges**: Unlock beautifully designed milestone badges for consistency, exploration, and mastery.
- **Daily Missions**: Maintain your streak by completing rotating daily coding tasks.

### 🤖 "NEO" - Your Personal AI Mentor (Powered by Gemini)
- **Context-Aware Assistance**: Need help? Neo analyzes your specific code and provides tailored hints without giving away the direct answer.
- **Complexity Analysis**: Receive real-time Big-O Time & Space complexity breakdowns.
- **AI Code Judge**: A strict, automated execution engine that evaluates logic, performance, and memory constraints.

### ⚔️ Real-Time Multiplayer Coding Battles
- **Battle Arena**: Challenge friends to intense, timed, 1v1 coding duals.
- **Matchmaking**: Send real-time invitations to friends and track win/loss ratios.
- **Live Sync**: Watch your opponent's progress in real-time. 

### 🔐 Secure Authentication & Data Persistence
- **Native Apple Sign-In**: Integrated natively using `AuthenticationServices`.
- **Google Sign-In Prepared**: Architecture fully built for seamless Google SDK dropping.
- **Account Linking**: Intelligent backend linking merges social accounts sharing the same email to prevent duplicates.
- **Offline Fallback Syncing**: Core progression is securely cached locally via `UserStorageService`. The moment your device regains connection, it silently syncs the data in the background.

---

## 📐 Architecture & Tech Stack

- **UI Framework**: SwiftUI only. No UIKit wrappers, no WebViews.
- **Architecture**: Strict MVVM (Model-View-ViewModel).
- **Design System**: A meticulously crafted custom Design System featuring Glassmorphism cards, Neon typography, Micro-animations, and centralized tokenized colors.
- **Security**: CryptoKit integration for on-device password hashing.
- **Performance**: Heavy utilization of `async/await`, `@StateObject` retention, and `Task` groups to guarantee consistent 120Hz frame rates on iPhone Pro models.

---

## 🚀 Getting Started

### Prerequisites
- macOS 13.0+
- Xcode 15.0+
- iPhone 16 Pro / iPhone 17 Pro Simulator (Recommended for best visual experience)

### Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/vasuparmar7360/iOS-app.git
   ```
2. Navigate into the project folder:
   ```bash
   cd iOS-app
   ```
3. Open the project in Xcode:
   ```bash
   open CodeXNebula.xcodeproj
   ```
4. Press **Cmd + R** to build and run the application on the Simulator.

> **Note on AI Features**: To enable Neo AI Mentor, create a `Secrets.plist` file in the root directory and add a String key `GEMINI_API_KEY` with your Google Gemini token. If omitted, the app gracefully falls back to a simulated mock AI system so the UI remains fully testable.

---

## 📸 Screenshots & Design
*(Upload and link your simulator screenshots here!)*

CodeX Nebula strictly adheres to Apple's Human Interface Guidelines while breaking the mold with its bespoke dark-mode cyberpunk aesthetic. Expect smooth interactive haptics, glow effects, and a highly polished UI.

---

## 🤝 Contribution
This project was developed by **Vasu Parmar**. 
For hackathons, portfolio showcases, or general feedback, feel free to open an issue or submit a pull request!

---
*CodeX Nebula - Enter the Grid.* 🚀
