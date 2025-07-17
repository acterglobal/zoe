# Zoe - Personal Workspace App

A modern, joyful Flutter app for organizing thoughts, tasks, and ideas with beautiful simplicity. Built with a Notion-like structure featuring pages and content blocks.

## Features

- **Personal Organization**: Create sheets for different aspects of your life
- **Mixed Content Blocks**: Combine todos, events, lists, and text in one place
- **Beautiful UI**: Modern design with smooth animations
- **Cross-platform**: Works on iOS, Android, Web, and Desktop
- **WhatsApp Integration**: Connect sheets to WhatsApp groups (UI demo)

## Architecture

The app follows a clean architecture pattern with:

- **SheetListProvider**: Manages all sheet operations and state
- **FirstLaunchProvider**: Handles first-time user experience
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
