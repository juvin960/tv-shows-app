# ShowBox


-   **This is a Flutter application that allows users to browse, search, and view detailed information about 
   TV shows.
   This project demonstrates clean architecture principles, structured state management, API integration,
   and testing practices suitable for real-world mobile applications.**


##    Overview
 **It showcases:
 **Clean separation of concerns
 **REST API integration
 **Provider-based state management
 **Unit and widget testing
 **Theme switching (Light/Dark mode)


##    Features
    **Search for TV shows
    **View detailed show information
    **Network image loading with fallback handling
    **Light and Dark theme support
    **Error handling and user-friendly messages
    



##  Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

*   [Flutter SDK](https://docs.flutter.dev) installed on your machine.
*   An IDE (VS Code, Android Studio, or IntelliJ).

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/juvin960/tv-shows-app.git
    ```
2.  **Install dependencies**
    ```bash
    flutter pub get
    ```
3.  **Run the app**
    ```bash
    flutter run
    ```

##  Project Structure

``The TV Show App is built using the MVVM (Model-View-ViewModel) architecture pattern to ensure maintainability,
testability, and scalability

*   `lib/models`: Data models.
*   `lib/view_models`: Logic and state management.
*   `lib/views`: UI screens and widgets.

##  Running Tests
- This project includes, ViewModel unit tests, Widget tests Mocked dependencies using Mockito

   **Run tests:**

```bash
flutter test

