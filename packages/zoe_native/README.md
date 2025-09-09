# zoe_native

A Flutter plugin built with flutter_rust_bridge that provides native Rust functionality for the Zoe application.

## Overview

This project uses [flutter_rust_bridge](https://cjycode.com/flutter_rust_bridge/) to seamlessly integrate Rust code with Flutter, providing high-performance native functionality while maintaining type safety and ease of use.

## Project Structure

* `rust/`: Contains the Rust source code
  * `rust/src/api/`: API definitions exposed to Flutter
  * `rust/src/lib.rs`: Main Rust library entry point
  * `rust/Cargo.toml`: Rust lib dependencies and configuration
* `lib/`: Contains the Dart code that interfaces with the Rust code
  * `lib/src/rust/`: Auto-generated Dart bindings (do not edit manually)
  * `lib/providers.dart` / `lib/src/providers`: the dart riverpod providers for the API 
* `flutter_rust_bridge.yaml`: Configuration for code generation
* `Cargo.toml`: Rust workspace dependencies and configuration
* Platform folders (`android/`, `ios/`, `linux/`, `macos/`, `windows/`): Platform-specific build configurations

## Dependencies

This plugin integrates with:
- `zoe-client`: Client library from the zoe-relay project
- `zoe-wire-protocol`: Wire protocol definitions from the zoe-relay project

## Development Workflow

### Updating Rust Dependencies

To update Rust dependencies, run:

```bash
cargo update
```

### Generating Bindings

After making changes to the Rust API, regenerate the Flutter bindings:

```bash
flutter_rust_bridge_codegen generate
```

### Building the Plugin

The plugin uses FFI and will automatically build the native code when you build your Flutter app. The `pubspec.yaml` is configured with:

```yaml
plugin:
  platforms:
    android:
      ffiPlugin: true
    ios:
      ffiPlugin: true
    linux:
      ffiPlugin: true
    macos:
      ffiPlugin: true
    windows:
      ffiPlugin: true
```

### Development Tips

1. **Making API Changes**: 
   - Modify Rust code in `rust/src/api/`
   - Run `flutter_rust_bridge_codegen generate` to update Dart bindings
   - The generated code will be in `lib/src/rust/`

2. **Testing Changes**:
   - Use `cargo test` in the `rust/` directory for Rust unit tests
   - Use `flutter test` for Dart/Flutter tests

3. **Debugging**:
   - Rust panics will be caught and converted to Dart exceptions
   - Use standard Rust debugging tools for the native code
   - Use Flutter debugging tools for the Dart side

## Configuration

The `flutter_rust_bridge.yaml` file configures:
- `rust_input`: Which Rust modules to expose
- `dart_output`: Where to generate Dart bindings
- `rust_preamble`: Common imports for generated code

## Platform Support

This plugin supports all major platforms:
- Android (via NDK)
- iOS (via Xcode/CocoaPods)
- Linux (via CMake)
- macOS (via Xcode/CocoaPods)  
- Windows (via CMake)

## More Information

For more details about flutter_rust_bridge, visit:
- [Official Documentation](https://cjycode.com/flutter_rust_bridge/)
- [GitHub Repository](https://github.com/fzyzcjy/flutter_rust_bridge)

