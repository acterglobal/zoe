#!/bin/bash

# Zoe Widgetbook Runner Script
echo "🚀 Starting Zoe Widgetbook..."

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ] || [ ! -f "lib/main.dart" ]; then
    echo "❌ Error: Please run this script from the widgetbook directory"
    exit 1
fi

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Generate directories
echo "🔧 Generating directories..."
dart run build_runner build -d

# Run Widgetbook
echo "🎨 Starting Widgetbook..."
echo "Available devices:"
flutter devices

echo ""
echo "Choose a device to run on:"
echo "1. iPhone 12 (iOS)"
echo "2. macOS (Desktop)"
echo "3. Chrome (Web)"
echo ""
read -p "Enter your choice (1-3): " choice

case $choice in
    1)
        flutter run -d 00008101-001A20E11E00801E
        ;;
    2)
        flutter run -d macos
        ;;
    3)
        flutter run -d chrome
        ;;
    *)
        echo "Running on default device..."
        flutter run
        ;;
esac
