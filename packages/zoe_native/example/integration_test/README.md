# Integration Tests for zoe_native Plugin

This directory contains comprehensive integration tests for the `zoe_native` Flutter plugin. These tests verify that the plugin works correctly with live Rust code and real Flutter applications.

## Test Files

### 1. `zoe_native_integration_test.dart`
**UI Integration Tests** - Tests the complete Flutter application flow with live Rust integration.

**What it tests:**
- Flutter app initialization with Rust library loading
- Client creation through Riverpod providers
- Group creation via the Flutter UI
- UI state updates when groups are created
- Log clearing functionality

**How it works:**
- Starts the actual Flutter example app
- Interacts with UI elements (buttons, text fields)
- Verifies that UI updates correctly when Rust operations complete
- Uses `testWidgets` and `IntegrationTestWidgetsFlutterBinding`

### 2. `direct_provider_test.dart`
**Direct Provider Integration Tests** - Tests Riverpod providers directly without the UI layer.

**What it tests:**
- Client creation through Riverpod providers using live Rust code
- Group creation through the client FFI interface
- Multiple group handling
- Client builder configuration
- Provider state management

**How it works:**
- Creates `ProviderContainer` with overridden client configuration
- Directly calls Rust FFI methods through the providers
- Verifies that the Rust integration works correctly
- Tests offline client functionality

## Key Features Tested

### ✅ Live Rust Integration
- **Real FFI calls**: Tests use actual Rust code, not mocks
- **Native library loading**: Verifies that the compiled Rust library loads correctly
- **Cross-platform compilation**: Tests that the native code builds on the target platform

### ✅ Riverpod State Management
- **Provider creation**: Tests that providers can create and manage clients
- **State updates**: Verifies that provider state updates when groups are created
- **Provider overrides**: Tests custom provider configurations for testing

### ✅ Client and Group Management
- **Client creation**: Tests creating clients with different configurations
- **Group creation**: Verifies that groups can be created through the Rust interface
- **Multiple groups**: Tests handling of multiple groups simultaneously
- **Offline functionality**: Tests client behavior when not connected to a server

## Running the Tests

### Locally
```bash
# From the zoe-app-groups root directory
./packages/zoe_native/run_integration_tests.sh

# Or directly from the example app directory
cd packages/zoe_native/example
flutter test integration_test/zoe_native_integration_test.dart
flutter test integration_test/direct_provider_test.dart
```

### In CI/CD
The tests are automatically run in GitHub Actions as part of the `zoe_native_plugin` job in the CI workflow. The CI environment:
- Sets up a virtual display (Xvfb) for headless testing
- Installs all necessary Linux dependencies
- Compiles the Rust native library
- Runs both test suites with verbose output

## Test Environment

### Dependencies
- **Flutter SDK**: Latest stable version
- **Rust toolchain**: For compiling the native library
- **Linux dependencies**: GTK, CMake, Ninja, etc. (for Linux builds)
- **Virtual display**: Xvfb for headless environments

### Configuration
- **Offline mode**: Tests run with `autoconnect: false` to avoid network dependencies
- **Temporary directories**: Each test uses isolated temporary storage
- **Provider overrides**: Custom client configurations for testing

## Test Architecture

### Integration Test Pattern
These tests follow the **example app pattern** for Flutter plugin integration testing:

1. **Create a minimal Flutter app** (`example/`) that uses the plugin
2. **Run integration tests** within this app context
3. **Avoid direct plugin testing** which can have build system issues

This approach ensures:
- ✅ Native libraries compile and link correctly
- ✅ Flutter can load and use the native code
- ✅ The plugin works in a real app environment
- ✅ Cross-platform compatibility is verified

### Provider Testing Pattern
The direct provider tests use **ProviderContainer** to test Riverpod providers in isolation:

1. **Create test containers** with overridden providers
2. **Call provider methods directly** without UI interaction
3. **Verify Rust FFI calls** work correctly
4. **Test provider state management** and updates

## Troubleshooting

### Common Issues

**Build failures:**
- Ensure Rust toolchain is installed and up to date
- Check that all Linux dependencies are installed
- Verify that the workspace dependencies are available

**Test timeouts:**
- Integration tests can take time due to native compilation
- CI environments may need longer timeouts
- Virtual display setup may need time to initialize

**Provider errors:**
- Ensure temporary directories are cleaned up between tests
- Check that provider overrides are configured correctly
- Verify that the Rust library initializes only once

### Debug Output
Both test files include debug output to help diagnose issues:
- Client IDs and group IDs are logged
- Success/failure messages are printed
- Provider state changes are tracked

## Contributing

When adding new integration tests:

1. **Follow the existing patterns** for consistency
2. **Test real functionality** - avoid mocking the Rust interface
3. **Include both UI and provider tests** when appropriate
4. **Add proper cleanup** for temporary resources
5. **Update this README** with new test descriptions

## CI Integration

These tests are automatically run in the GitHub Actions CI pipeline:
- **On every PR** to main/develop branches
- **On every push** to main/develop branches
- **As part of the `zoe_native_plugin` job**

The CI ensures that:
- ✅ Integration tests pass on Linux
- ✅ Native compilation works correctly
- ✅ No regressions are introduced
- ✅ Plugin functionality remains stable

