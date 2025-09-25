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

tl;dr command:
```
cargo update && flutter_rust_bridge_codegen generate && cargo test && flutter test
```

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

## Using local config

By default the plugin uses prebuilt binaries from github, to make it built locally you can either run it with `CARGOKIT_DISABLE_PRECOMPILED_BINARIES=1 flutter [...]`

or you create a `cargokit_options.yaml` in the main package folder `packges/zoe_native` overriding the configuration as follows:

```yaml
# Enables verbose logging of Cargokit during build
verbose_logging: true

# Opts out of using precompiled binaries. If crate has configured
# and deployed precompiled binaries, these will be by default used whenever Rustup
# is not installed. With `use_precompiled_binaries` set to false, the build will
# instead be aborted prompting user to install Rustup.
use_precompiled_binaries: false
```

For more details [consult the cargokit documentation](https://github.com/irondash/cargokit/blob/main/docs/architecture.md#configuring-cargokit).

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

