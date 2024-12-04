# Changelog

## Second Commit: Added Core App and Main View.

### + Added Files:

#### 1. `UserModel.swift`
- **Purpose**: Defines the `User` model structure for representing user information.
- **Key Properties**:
  - `name`: User's full name.
  - `username`: User's unique identifier.
  - `currentStreak`: The number of consecutive days the user has maintained a workout streak.
  - `bearCoins`: Represents the in-app currency earned by the user.

#### 2. `MainViewModel.swift`
- **Purpose**: Serves as the main view model for managing core application logic and state.
- **Key Additions**:
  - `user`: An instance of `User`, representing the current user data.
  - `workoutFeed`: An array of `WorkoutEntry` objects, representing the user's workouts.
  - `healthKitVM`: An instance of `HealthKitViewModel` for handling HealthKit interactions.
- **Functions**:
  - `init(user: User)`: Initializes the view model and triggers HealthKit authorization.

#### 3. `HealthKitViewModel.swift`
- **Purpose**: Handles all HealthKit-related operations and maintains the authorization state.
- **Key Additions**:
  - `authorizationStatus`: Represents the current HealthKit authorization status.
  - `requestHealthKitAuthorization()`: Initiates HealthKit authorization.
  - `updateAuthorizationStatus()`: Checks and updates the authorization status.

#### 4. `HomePage.swift`
- **Purpose**: The main SwiftUI view for the app's home screen.
- **Key Components**:
  - Uses `NavigationView` and `ScrollView` for structuring the UI.
  - Integrates `HomeNavBar`, `HomePageCell`, and `HomePageRibbon` for a complete layout.
  - Triggers HealthKit checks with the `checkHealthKitAuthorization()` function.

#### 5. `HomeNavBar.swift`
- **Purpose**: A subview representing the top navigation bar on the home page.
- **Key Properties**:
  - Displays the current streak and bear coin count.

#### 6. `HomePageCell.swift`
- **Purpose**: Represents individual workout entries in the home page feed.
- **Key Properties**:
  - `workout`: A `WorkoutEntry` object, displaying workout details like title, date, and earned coins.

#### 7. `HomePageRibbon.swift`
- **Purpose**: Provides a ribbon at the bottom of the home page to initiate new workouts or display prompts.
- **Key Properties**:
  - `showingWorkoutPrompt`: A binding to trigger the display of a workout initiation prompt.


## Third Commit: Added Health Kit functionality + other stuff.
- **Added**: A lot.


## Forth Commit: Uploaded the backend to Firebase for user storage and functionality

### + Added Files:
#### 1. `ExerciseListView.swift`
- **Purpose**: Displays a list of workouts to the user.
- **Key Properties**:
  - `SearchBar` : Adds a search feature for users to look up specific workouts.

#### 2. `ExerciseDetailView.swift`
- **Purpose**: Presents information about a specific workout to the users. 
- **Key Properties**:
  Categories include:
    - workout type
    - muscle group
    - equipment needed (if applicable)
    - workout dificulty
    - instructions
      
- #### Minor updates made to `ExerciseViewModel.swift`
- #### Updates to artwork and UI
 
