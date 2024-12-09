# UrsaFit - iOS Fitness Tracking App

A gamified fitness tracking application that encourages users to maintain consistent workout habits through a streak-based system, leveraging Apple's HealthKit for workout data and incorporating social features to enhance user engagement.

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Core Features](#2-core-features)
3. [Tech Stack](#3-tech-stack)
4. [Getting Started](#4-getting-started)

## 1. Project Overview

UrsaFit motivates users to maintain consistent exercise habits through a gamified experience similar to Duolingo but for fitness. The app integrates with Apple's HealthKit for workout tracking and includes social features for accountability and engagement.

## 2. Core Features

### 2.1 User Management

- Firebase Authentication
- Custom user profiles
- Workout schedule preferences
- Streak tracking system

### 2.2 Workout Features

- Real-time workout tracking
- Integration with HealthKit
- Multiple workout types support 
- Streak maintenance system
- Stats visualization

### 2.3 Gamification Features

- Bear coin reward system
- Streak freezes
- Uncle Larry donation system
- Achievement tracking

### 2.4 Platform Features

- MVVM Architecture
- Firebase Firestore integration
- HealthKit data synchronization
- Real-time workout statistics

## 3. Tech Stack

### Core Technologies

- Swift
- SwiftUI
- Firebase (Auth, Firestore)
- HealthKit

### Key Frameworks

- FirebaseUI
- Firebase Authentication
- Cloud Firestore
- Apple HealthKit

### Development Tools

- Xcode
- Firebase Console
- Git

## 4. Getting Started

### Prerequisites

- Xcode 14.0+
- iOS 16.0+
- Firebase account
- Apple Developer account

### Installation

1. **Clone the Repository**

```bash
git clone https://github.com/yourusername/UrsaFit.git
```

2. **Install Dependencies**

```bash
# Navigate to project directory
cd UrsaFit

# Install CocoaPods dependencies
pod install
```

3. **Configure Firebase**

- Create a new Firebase project
- Add iOS app in Firebase Console
- Download GoogleService-Info.plist
- Add to project
- Enable Authentication methods

4. **Configure HealthKit**

- Add HealthKit capability in Xcode
- Configure required permissions

### Running the App

3. Build and run lmao


### Core Implementation Details

#### Architecture

- **MVVM Pattern**: Clear separation of concerns
- **Coordinator Pattern**: Navigation management
- **Repository Pattern**: Data access abstraction

#### Key Components

- **Authentication**: Firebase Auth with email/password
- **Database**: Cloud Firestore for user data
- **Health Data**: HealthKit integration
- **State Management**: Combine framework

### Next Steps

1. Implement advanced workout tracking features
2. Add social challenges system
3. Expand gamification elements
4. Enhance data analytics
5. Add workout recommendations
6. Implement achievement system

## License

This project is licensed under the MIT License.
