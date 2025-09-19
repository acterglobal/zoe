#!/bin/bash

# Script to run integration tests for zoe_native package
# This script ensures proper setup and runs the live Rust integration tests
#
# Usage: ./run_integration_tests.sh [device]
# Examples:
#   ./run_integration_tests.sh           # Auto-detect device
#   ./run_integration_tests.sh linux     # Force Linux device
#   ./run_integration_tests.sh macos     # Force macOS device
#   FLUTTER_DEVICE=linux ./run_integration_tests.sh  # Via environment variable

set -e  # Exit on any error

echo "🚀 Running zoe_native Integration Tests"
echo "======================================="

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Must be run from the zoe_native package directory"
    echo "   Expected to find pubspec.yaml in current directory"
    exit 1
fi

# Check if example app exists
if [ ! -d "example" ]; then
    echo "❌ Error: Example app not found"
    echo "   Expected: example/ directory"
    exit 1
fi

echo "📦 Installing dependencies for example app..."
cd example
flutter pub get

echo "🔍 Analyzing integration tests..."
flutter analyze integration_test/ || echo "⚠️ Analysis completed with warnings (continuing...)"

echo "🧪 Running integration tests in example app..."
echo ""
echo "Note: This runs the integration tests in a real Flutter app context"
echo "      which avoids the CMake/build issues of direct plugin testing."
echo ""

# Setup virtual display for headless environments (like CI)
if [[ -n "${CI}" ]] || [[ -n "${GITHUB_ACTIONS}" ]]; then
    echo "🖥️  Setting up virtual display for CI environment..."
    export DISPLAY=:99
    if ! pgrep -x "Xvfb" > /dev/null; then
        Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
        sleep 3
        echo "   Virtual display started on :99"
    fi
fi

# Determine device flag
DEVICE_FLAG=""
DEVICE=""

# Priority: 1) Command line argument, 2) Environment variable, 3) Auto-detect
if [[ -n "$1" ]]; then
    DEVICE="$1"
    echo "🖥️  Using device from command line: $DEVICE"
elif [[ -n "${FLUTTER_DEVICE}" ]]; then
    DEVICE="${FLUTTER_DEVICE}"
    echo "🖥️  Using device from environment variable: $DEVICE"
elif [[ -n "${CI}" ]] || [[ -n "${GITHUB_ACTIONS}" ]]; then
    # Auto-detect for CI - assume Linux
    DEVICE="linux"
    echo "🖥️  Auto-detected device for CI environment: $DEVICE"
else
    # Local development - let Flutter auto-detect
    echo "🖥️  Using Flutter's auto-detection for device selection"
fi

# Set device flag if device is specified
if [[ -n "$DEVICE" ]]; then
    DEVICE_FLAG="-d $DEVICE"
fi

# Run the integration tests with verbose output
echo "🧪 Running Direct Provider Integration Tests..."
flutter test integration_test/direct_provider_test.dart --verbose $DEVICE_FLAG

echo ""
echo "🧪 Running UI Integration Tests..."
flutter test integration_test/zoe_native_integration_test.dart --verbose $DEVICE_FLAG

echo ""
echo "✅ All integration tests completed successfully!"
echo ""
echo "Integration test summary:"
echo "- ✅ UI Integration Tests: Tests the Flutter UI with live Rust integration"
echo "- ✅ Direct Provider Tests: Tests Riverpod providers with live Rust code"
echo ""
echo "These tests verified:"
echo "  • Rust library loading and initialization"
echo "  • Client creation through Riverpod interface"
echo "  • Group creation using live Rust code"
echo "  • Group visibility in providers"
echo "  • Multiple group handling"
echo "  • Offline client functionality"
echo "  • Cross-platform native library compilation and linking"
