# Zoe - Personal Workspace App

A modern, joyful Flutter app for organizing thoughts, tasks, and ideas with beautiful simplicity. Built with a Notion-like structure featuring pages and content blocks.

## Features

### 🎉 Welcome Experience
- Beautiful onboarding screen with smooth animations
- Joyful design with modern UI elements
- Automatic setup with sample data

### 🏠 Home Dashboard
- Personalized greetings based on time of day
- Today's tasks overview with progress tracking
- Upcoming events and this week's schedule
- Quick actions for common tasks

### 📄 Pages System
- Create unlimited pages with custom titles and descriptions
- Add custom emojis to pages
- Organize content with different block types
- Inline editing like Notion

### 📋 Content Blocks
- **To-do Lists**: Track tasks with checkboxes and due dates
- **Events**: Schedule and manage events with dates and descriptions
- **Lists**: Create simple bullet-point lists
- **Text**: Add rich text content

### 🎨 Modern Design
- Clean, minimalist interface
- Smooth animations and transitions
- Consistent color scheme and typography
- Responsive layout

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Rust toolchain (for flutter_rust_bridge)
- macOS, iOS, Android, or Web platform support

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd zoey
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Architecture

### State Management
- Uses Provider for state management
- Centralized app state with `AppStateProvider`
- Reactive UI updates

### Project Structure
```
lib/
├── common/
│   ├── models/          # Data models
│   └── providers/       # State management
├── screens/            # Main app screens
├── widgets/            # Reusable UI components
└── main.dart          # App entry point
```

### Key Components
- **AppStateProvider**: Manages global app state
- **ZoeSheet**: Core sheet model with content blocks
- **ContentBlock**: Abstract base for different content types
- **Modern Widgets**: Custom UI components with animations

## Content Block Types

1. **TodoBlock**: Task management with checkboxes
2. **EventBlock**: Event scheduling and tracking
3. **ListBlock**: Simple bullet-point lists
4. **TextBlock**: Rich text content

## Design Philosophy

- **Joyful**: Delightful animations and interactions
- **Modern**: Clean, contemporary design language
- **Productive**: Focus on getting things done
- **Flexible**: Adaptable to different use cases

## Technologies Used

- **Flutter**: Cross-platform UI framework
- **Dart**: Programming language
- **Provider**: State management
- **Google Fonts**: Typography
- **Flutter Animate**: Smooth animations
- **flutter_rust_bridge**: Rust integration

## Future Enhancements

- [ ] Data persistence (local storage)
- [ ] Cloud synchronization
- [ ] Advanced text formatting
- [ ] File attachments
- [ ] Collaboration features
- [ ] Custom themes
- [ ] Search functionality
- [ ] Export options

## Contributing

This is a prototype application. Feel free to explore the code and suggest improvements!

## License

This project is for demonstration purposes.
