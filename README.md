# Zoe - Personal Workspace App

A modern, joyful Flutter app for organizing thoughts, tasks, and ideas with beautiful simplicity. Built with a Notion-like structure featuring sheets and dynamic content blocks.

## Features

- **Personal Organization**: Create and manage sheets for different aspects of your life
- **Dynamic Content Blocks**: Seamlessly combine todos, events, bullet lists, and text in one place
- **Real-time Updates**: Instant data persistence with every keystroke
- **Beautiful UI**: Modern design with smooth animations and intuitive interactions
- **Cross-platform**: Works on iOS, Android, Web, and Desktop
- **Robust State Management**: Built with Riverpod for reliable, reactive state handling

## Architecture

The app follows a clean, modular architecture with separation of concerns:

### Core Components
- **SheetListProvider**: Manages all sheet operations and state using StateNotifier
- **Content System**: Modular content providers for each content type
- **Router Integration**: Go Router for smooth navigation
- **Theme System**: Comprehensive theming with dark/light mode support

### Content Management
- **TextContentListNotifier**: Handles text content with immediate persistence
- **TodosContentListNotifier**: Manages task lists with real-time updates
- **EventsContentListNotifier**: Event scheduling and tracking
- **BulletsContentListNotifier**: Dynamic bullet-point lists

### State Management
- **Riverpod Integration**: Modern reactive state management
- **Provider Family**: Stable controllers for form inputs
- **StateNotifier Pattern**: Predictable state updates
- **Auto-dispose**: Efficient memory management

## Content Block Types

1. **Text Content**: Rich text with titles and descriptions
2. **Todo Lists**: Task management with checkboxes and descriptions
3. **Event Blocks**: Event scheduling with titles and details
4. **Bullet Lists**: Dynamic bullet-point lists with real-time editing

## Design Philosophy

- **Joyful**: Delightful animations and micro-interactions
- **Modern**: Clean, contemporary design language with relevant icons
- **Productive**: Focus on getting things done efficiently
- **Flexible**: Adaptable to different organizational needs
- **Reliable**: Robust error handling and data persistence

## Technologies Used

- **Flutter**: Cross-platform UI framework
- **Dart**: Programming language
- **Riverpod**: Advanced state management
- **Go Router**: Declarative routing
- **Google Fonts**: Typography
- **Flutter Animate**: Smooth animations
- **flutter_rust_bridge**: Rust integration for performance
- **SharedPreferences**: Local data persistence

## Key Features Implemented

✅ **Real-time Data Persistence**: Every change saves instantly
✅ **Stable Text Editing**: No reverse typing or controller recreation issues
✅ **Modular Content System**: Clean separation of content types
✅ **Robust Error Handling**: Graceful fallbacks and error recovery
✅ **Modern UI/UX**: Bottom sheets, smooth animations, and intuitive design
✅ **Cross-platform Support**: Works across all Flutter-supported platforms
✅ **Theme Management**: Light/dark mode with system preference detection
✅ **Navigation System**: Clean routing with Go Router integration

## Future Enhancements

- [ ] Cloud synchronization
- [ ] Advanced text formatting (rich text editor)
- [ ] File attachments and media support
- [ ] Collaboration features
- [ ] Custom themes and personalization
- [ ] Advanced search functionality
- [ ] Export options (PDF, Markdown)
- [ ] Offline-first architecture
- [ ] Performance optimizations

## Getting Started

1. **Prerequisites**: Flutter SDK (latest stable version)
2. **Installation**: 
   ```bash
   flutter pub get
   flutter run
   ```
3. **Platform Setup**: Follow Flutter's platform-specific setup guides

## Contributing

This is a fully functional personal workspace application. Contributions are welcome! Please follow the existing architecture patterns and state management approaches.

## License

This project is for demonstration and educational purposes.
