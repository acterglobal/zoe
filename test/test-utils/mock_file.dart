import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

class MockImagePickerPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements ImagePickerPlatform {}

class MockXFile extends Mock implements XFile {}
