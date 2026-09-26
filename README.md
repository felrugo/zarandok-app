# Zarandok App

A Flutter-based songbook and lyrics application based on the hungarian lutheran songbook called **Zarándok Ének**, designed for song browsing, searching, and multimedia accompaniment.

## 🚀 Features

*   **Song Discovery:** Easily find songs through a search delegate or browse via an organized Table of Contents.
*   **Multimedia Integration:** Integrated YouTube player supporting both **Karaoke Mode** and **Song Mode**.
*   **Offline:** Built-in download management to ensure access to content even without an active internet connection.
*   **Cross-Platform:** Developed with Flutter to provide a consistent experience across Android, iOS, Web, and Desktop.

## 🛠️ Tech Stack

*   **Framework:** [Flutter](https://flutter.dev/)
*   **Language:** [Dart](https://dart.dev/)
*   **Key Dependencies:**
    *   `youtube_player_iframe`: For high-performance web-based YouTube playback.
    *   `url_launcher`: To handle external links and deep linking.
    *   `flutter_svg`: For crisp, scalable vector graphics.

## 📦 Installation & Setup

### Prerequisites

*   [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.2.0 or higher recommended)
*   [Dart SDK](https://dart.dev/get-started/sdk)
*   Android Studio / Xcode / VS Code (for platform-specific builds)

### Getting Started

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/felrugo/zarandok-app.git
    cd zarandok-app
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the application:**
    ```bash
    # For Android
    flutter run
    
    # For iOS (macOS only)
    flutter run
    
    # For Web
    flutter run -d chrome
    ```

## 📂 Project Structure

*   `lib/`: Contains the core application logic.
    *   `main.dart`: Application entry point.
    *   `songsearch.dart`: Implementation of the song search functionality.
    *   `youtube_view.dart`: Logic for the integrated YouTube player.
    *   `download_manager.dart`: Handles offline content acquisition.
    *   `tableofcontents.dart`: Navigation and structural organization of songs.
*   `assets/`: Static assets including icons and configuration files.
*   `test/`: Widget and unit tests.

## 📄 License

This project is licensed under the **GNU General Public License v3.0 (GPLv3)**. See the [LICENSE](LICENSE) file for details.

