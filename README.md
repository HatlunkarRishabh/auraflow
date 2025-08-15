# AuraFlow 🌊

**A modern, cross-platform productivity app for managing goals, tasks, and ideas.**

AuraFlow is a beautifully designed, feature-rich productivity tool built with Flutter. It's designed to provide a seamless and intuitive experience for users on both mobile and desktop platforms, helping them define and track their goals, manage detailed tasks, and capture fleeting ideas with digital sticky notes.

This project is the capstone of a comprehensive Flutter learning journey, demonstrating a wide range of modern app development principles from basic layouts to advanced state management and cross-platform responsive design.

![AuraFlow App Showcase](placeholder.png) 
*(Note: You would replace this with a screenshot or GIF of your app)*

---

## ✨ Features

*   **Goal Management:** Create, track, and manage your long-term goals.
    *   **Progress Visualization:** Goals automatically calculate and display a progress bar based on the completion of their tasks.
*   **Hierarchical Task System:**
    *   **Detailed Tasks:** Each goal contains a list of tasks with priorities (Low, Medium, High) and optional due dates.
    *   **Sub-Tasks:** Break down complex tasks into smaller, manageable checklists.
*   **Sticky Note Board:** A free-form, staggered grid layout for capturing quick thoughts and ideas that don't yet belong to a specific goal.
    *   **Markdown Support:** Write notes using Markdown for rich text formatting.
    *   **Color Customization:** Personalize your notes with a full-spectrum color picker.
*   **Cross-Platform Responsive UI:**
    *   **Mobile:** A clean, intuitive interface with a `BottomNavigationBar`.
    *   **Desktop (Windows, macOS, Linux):** A professional "Master-Detail" layout that utilizes a `NavigationRail` and side-by-side views to make the most of wider screens.
*   **Personalization:**
    *   **Light & Dark Mode:** A persistent theme switcher to match your preference.
    *   **Accent Color:** Choose a primary accent color that is applied across the entire application theme.
*   **Data Persistence:** All goals, tasks, and settings are saved locally on your device using the high-performance **Hive** database, ensuring your data is always available, even offline.

---

## 🛠️ Built With

This project showcases a modern, scalable Flutter architecture.

*   **Framework:** [Flutter](https://flutter.dev/) (v3.x)
*   **Language:** [Dart](https://dart.dev/)
*   **State Management:** [Provider](https://pub.dev/packages/provider) - For a clean separation of business logic from the UI using `ChangeNotifier`.
*   **Database:** [Hive](https://pub.dev/packages/hive) - A fast, lightweight, and pure-Dart NoSQL database for local persistence.
*   **Responsive UI:** [responsive_builder](https://pub.dev/packages/responsive_builder) - For creating adaptive layouts for mobile and desktop.
*   **UI Enhancements:**
    *   [google_fonts](https://pub.dev/packages/google_fonts) - For beautiful, custom typography.
    *   [flutter_staggered_grid_view](https://pub.dev/packages/flutter_staggered_grid_view) - For the dynamic sticky note board layout.
    *   [flutter_markdown](https://pub.dev/packages/flutter_markdown) - For rendering rich text in sticky notes.
*   **Code Generation:** [build_runner](https://pub.dev/packages/build_runner) & [hive_generator](https://pub.dev/packages/hive_generator) - To automate the creation of Hive `TypeAdapter`s.
*   **App Icon:** [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) - For automatically generating platform-specific app icons.

---

## 🚀 Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

*   You must have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed (version 3.10 or higher is recommended).
*   An IDE such as [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio).
*   Desktop support enabled for your target platform (e.g., `flutter config --enable-windows-desktop`).

### Installation & Setup

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/HatlunkarRishabh/auraflow.git
    cd auraflow
    ```
2.  **Get dependencies:**
    ```sh
    flutter pub get
    ```
3.  **Run the Hive code generator:**
    This step is crucial. It generates the necessary files for the database to work.
    ```sh
    dart run build_runner build --delete-conflicting-outputs
    ```
4.  **Run the app:**
    Select your target device (e.g., a mobile emulator, Chrome, or your desktop) and run the application.
    ```sh
    flutter run
    ```

---

## 📜 What I Learned

This project served as a comprehensive, hands-on journey through the Flutter ecosystem, covering:
*   Advanced state management patterns and the importance of separating UI from logic.
*   Robust local data persistence with a NoSQL database (Hive).
*   Best practices for building responsive UIs that feel native on both mobile and desktop.
*   The power of code generation to reduce boilerplate and prevent errors.
*   Implementing a polished, aesthetically pleasing user interface from scratch.

---

## 👤 Author

**Rishabh Hatlunkar** 
*(You can add your contact info or portfolio links here if you wish)*
*   GitHub: [@HatlunkarRishabh](https://github.com/HatlunkarRishabh)