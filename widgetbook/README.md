# Zoe Widgetbook

This is the Widgetbook catalog for the Zoe app. It provides a comprehensive view of all the UI components used in the Zoe application.

## Setup

The Widgetbook is set up as a separate Flutter app within the main Zoe project. It follows the [Widgetbook documentation](https://docs.widgetbook.io/quick-start) for proper setup.

### Project Structure

```
zoe/
├── lib/                    # Main Zoe app
├── widgetbook/            # Widgetbook catalog
│   ├── lib/
│   │   ├── main.dart      # Widgetbook app entry point
│   │   └── widgets.dart   # Widget use cases
│   └── pubspec.yaml       # Widgetbook dependencies
└── pubspec.yaml           # Main app dependencies
```

### Dependencies

The Widgetbook app includes:
- `widgetbook: ^3.16.0` - Main Widgetbook package
- `widgetbook_annotation: ^3.7.0` - Annotations for use cases
- `widgetbook_generator: ^3.16.0` - Code generation
- `build_runner: ^2.4.13` - Build system
- `zoe: path: ../` - Path dependency to main app

### Running Widgetbook

1. Navigate to the widgetbook directory:
   ```bash
   cd widgetbook
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Generate the directories file:
   ```bash
   dart run build_runner build -d
   ```

4. Run the Widgetbook app:
   ```bash
   flutter run
   ```

### Adding New Widgets

To add new widgets to the catalog:

1. Import the widget in `widgetbook/lib/widgets.dart`
2. Create use cases with the `@widgetbook.UseCase` annotation
3. Run `dart run build_runner build -d` to regenerate the directories
4. The new widgets will appear in the Widgetbook interface

### Current Widgets

The catalog currently includes:

#### Button Widgets
- **ZoePrimaryButton** - Primary action buttons with glassy design
- **ZoeSecondaryButton** - Secondary action buttons
- **ZoeFloatingActionButton** - Floating action buttons with glassy effects

#### Container Widgets
- **GlassyContainer** - Glassmorphism container with customizable blur
- **EmojiWidget** - Emoji display widget with editing capabilities

### Features

- **Interactive Testing** - All widgets are interactive and can be tested
- **Multiple Variants** - Each widget has multiple use cases showing different states
- **Responsive Design** - Widgets adapt to different screen sizes
- **Theme Support** - Widgets respect the app's theme system

### Development Workflow

1. Develop widgets in the main Zoe app
2. Add use cases to the Widgetbook catalog
3. Test widgets in isolation using Widgetbook
4. Iterate and refine based on Widgetbook testing
5. Integrate back into the main app

This setup ensures that all UI components are properly tested and documented, making it easier to maintain consistency across the Zoe application.
