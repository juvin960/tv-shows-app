# ShowBox


-   **This is a Flutter application that allows users to browse, search, and view detailed information about 
   TV shows.
   This project demonstrates clean architecture principles, structured state management, API integration,
   and testing practices suitable for real-world mobile applications.**


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


##    Features
    **Search for TV shows
    **View detailed show information
    **Network image loading with fallback handling
    **Light and Dark theme support
    **Error handling and user-friendly messages



##  Project Structure

``The TV Show App is built using the MVVM (Model-View-ViewModel) architecture pattern to ensure maintainability,
testability, and scalability

*    `data`: Repository.
*   `model`: Models data.
*   `Presentation`: `view_models`: Logic and state management.
*                    `views` : UI screens and widgets.
*          

##  Running Tests
- This project includes, ViewModel unit tests, Widget tests Mocked dependencies using Mockito

   **Run tests:**

```bash
flutter test
```

 *build APKs for specific environments:*
```bash
flutter build apk --flavor production --release
```
# License
-  Distributed under the MIT License. See LICENSE for more information.


Author
Juvin Achieng,
juvin.omondi@gmail.com
https://github.com/juvin960/





