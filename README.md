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

```yaml
dependencies:
  ui_textfield_cache_flutter:
    git: https://github.com/GitHubStuff/ui_textfield_cache_flutter.git
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

## License

Distributed under the Apache License. See `LICENSE.txt` for more information.

## Finally

Be kind to each other.
