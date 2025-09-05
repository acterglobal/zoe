import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
// Import Zoe widgets
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_icon_container_widget.dart';

// Glassy Container Widgets
@widgetbook.UseCase(name: 'Default', type: GlassyContainer)
Widget buildGlassyContainerUseCase(BuildContext context) {
  final containerText = context.knobs.string(
    label: 'Container Text',
    description: 'The text displayed in the glassy container',
    initialValue: 'Glassy Container',
  );
  
  final blurRadius = context.knobs.string(
    label: 'Blur Radius',
    description: 'The blur radius of the glassy effect (0-50)',
    initialValue: '12',
  );
  
  final borderOpacity = context.knobs.string(
    label: 'Border Opacity',
    description: 'The opacity of the border (0-1)',
    initialValue: '0.15',
  );

  return GlassyContainer(
    blurRadius: double.tryParse(blurRadius) ?? 12,
    borderOpacity: double.tryParse(borderOpacity) ?? 0.15,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(containerText),
    ),
  );
}

@widgetbook.UseCase(name: 'With Custom Blur', type: GlassyContainer)
Widget buildGlassyContainerWithBlurUseCase(BuildContext context) {
  final containerText = context.knobs.string(
    label: 'Container Text',
    description: 'The text displayed in the glassy container',
    initialValue: 'Glassy Container with Custom Blur',
  );
  
  final blurRadius = context.knobs.string(
    label: 'Blur Radius',
    description: 'The blur radius of the glassy effect (0-50)',
    initialValue: '20',
  );
  
  final surfaceOpacity = context.knobs.string(
    label: 'Surface Opacity',
    description: 'The opacity of the surface (0-1)',
    initialValue: '0.85',
  );

  return GlassyContainer(
    blurRadius: double.tryParse(blurRadius) ?? 20,
    surfaceOpacity: double.tryParse(surfaceOpacity) ?? 0.85,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(containerText),
    ),
  );
}

// Icon Container Widgets
@widgetbook.UseCase(name: 'Default', type: ZoeIconContainer)
Widget buildZoeIconContainerUseCase(BuildContext context) {
  final size = context.knobs.string(
    label: 'Size',
    description: 'The size of the icon container (24-200)',
    initialValue: '72',
  );

  return ZoeIconContainer(
    icon: Icons.star,
    size: double.tryParse(size) ?? 72,
  );
}

@widgetbook.UseCase(name: 'With Color', type: ZoeIconContainer)
Widget buildZoeIconContainerWithColorUseCase(BuildContext context) {
  final iconColor = context.knobs.color(
    label: 'Icon Color',
    description: 'The color of the icon',
    initialValue: Colors.amber,
  );
  
  final backgroundColor = context.knobs.color(
    label: 'Background Color',
    description: 'The background color of the container',
    initialValue: Colors.amber.withValues(alpha: 0.15),
  );

  return ZoeIconContainer(
    icon: Icons.star,
    iconColor: iconColor,
    backgroundColor: backgroundColor,
  );
}
