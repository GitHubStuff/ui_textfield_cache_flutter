# Flutter Caching and Sorting UI Project

## Overview

This Flutter project provides a robust solution for caching user input and dynamically sorting cached entries based on user interaction. Utilizing a combination of Hive for local storage and a custom implementation for state management with Flutter Bloc, the project aims to enhance user experience by offering an efficient way to handle and reuse user input.

## Features

- **Caching User Input:** Leverages Hive, a lightweight and efficient local storage solution, to cache user inputs directly on the device.
- **Dynamic Input Sorting:** Implements custom sorting logic within the Cubit to reorder cached entries based on user search queries, improving the relevance of suggestions.
- **UI Components:** Offers a responsive UI with a focus on accessibility, including a TextField for input and a ListView for displaying cached entries.
- **Dark Mode Support:** Automatically adjusts UI elements to match the system's theme, providing a seamless experience in both light and dark modes.

## Getting Started

### Installation

1. Clone the repository to your local machine:
   ```bash
   git clone https://github.com/your-repository/flutter-caching-sorting-ui.git
   ```

2. Navigate to the project directory:
   ```bash
   cd flutter-caching-sorting-ui
   ```

3. Get the dependencies:
   ```bash
   flutter pub get
   ```

4. Run the project:
   ```bash
   flutter run
   ```

## Usage

- Launch the app on your device or emulator.
- Enter text into the provided input field. Submitted entries will be cached locally.
- As you type in the input field, the list of cached entries dynamically sorts based on the relevance to your current input.
- Select any cached entry from the list to auto-fill the input field.

## Dependencies

- **hive_flutter**: For local storage and caching mechanism.
- **flutter_bloc**: For managing the app's state in a reactive way.
- **flutter_modular**: For dependency injection and modularization of the app.
- **ui_marquee_flutter**: To display scrolling text in UI elements.

## Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Acknowledgments

- Flutter Team for providing an excellent framework for mobile development.
- The Hive community for their efficient local storage solution.
- And every contributor who has helped shape this project.
