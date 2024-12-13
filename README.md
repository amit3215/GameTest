#**GameApp**

GameApp is an iOS application built using the MVVM (Model-View-ViewModel) architecture. The app showcases a list of games retrieved from a remote server, with features such as image caching and modularized components for improved scalability and testability.

#**Features**
* **Game Listing:** Fetch and display a list of games from a remote server.
* **Image Caching:** Efficiently cache images to minimize redundant network calls.
* **Modular Design:** Adheres to MVVM architecture with distinct separation of concerns.
* **Unit Testing:** Comprehensive test cases for services and view models to ensure reliability.
* **Combine Framework:** Implements reactive programming patterns for data binding and event handling.



#**Architecture**
The project follows the MVVM Architecture to ensure a clean separation of concerns:

* Model: Defines the data structure and represents the app's business logic.
* ViewModel: Handles the app's state, business rules, and transformations between the Model and View layers.
* View: Displays the data and delegates user interactions to the ViewModel.


#**Folder Structure**
* ViewModel: Contains ViewModel classes that manage app state and logic.
* View: Hosts all the UI components and views.
* Modal: Houses data models used throughout the app.
* Services: Encapsulates network calls and other services.
* Utility: Contains reusable helper functions and classes.
* Assets.xcassets: Stores app assets such as icons and images.
* Preview Content: Mock data and previews for SwiftUI components.



#**Dependencies**
The app leverages the following technologies and frameworks:

* Combine: For reactive programming and data streams.
* UIKit: To build user interfaces.
* NSCache: For efficient image caching.


#**Installation**

Clone this repository:
bash
Copy code
git clone <repository-url>
Open GameApp.xcodeproj in Xcode.
Build and run the project on your desired simulator or device.


#**Testing**
The project includes unit and UI tests to validate its functionality.

#**How to Run Tests**
Open the Xcode project.
Select the Product > Test menu, or press Command + U.

#**Test Coverage**
* GameService: Ensures proper fetching of games and handling of network responses.
* ImageCaching: Validates caching mechanisms for optimized performanc


#**How It Works**

##**Fetching Games:

1 . The GameService class retrieves data from the server using Combine publishers.
2 . Data is parsed into Game model objects and passed to the ViewModel.

##**Image Loading:

1. Images are fetched from URLs and cached using the DefaultImageCache class, which conforms to the ImageCache protocol.
2. Subsequent requests for the same image retrieve it directly from the cache.

##**MVVM Flow:

The ViewModel transforms raw data from the services into displayable formats for the View.
The View updates in response to changes in the ViewModel via bindings.


#**Future Improvements**
* Add localization support for a multilingual user base.
* Enhance the UI with additional animations and more refined layouts.
* Implement offline caching for game data to improve the app's usability without an internet connection.
* Expand test coverage to include UI tests for SwiftUI views.
* More commenting if gets more time

# GameTest
