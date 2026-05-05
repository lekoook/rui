import 'package:rui/screens/robot_view.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme darkColorScheme = ColorSchemes.darkSlate.copyWith(
      border: () => Colors.gray
    );
    return ShadcnApp(
      theme: ThemeData(
        // Customize light mode colors and design tokens.
        colorScheme: ColorSchemes.lightSlate,
        // Corner radius scale applied across components.
        radius: 0.25,
        // Global size scale multiplier.
        scaling: 1.2,
        // Semi-translucent surfaces with blur create a glassy look.
        surfaceOpacity: 0.8,
        surfaceBlur: 10,
        // Swap default fonts for sans/mono text styles.
        typography: Typography.geist(
          sans: TextStyle(
            fontFamily: 'Inter',
          ),
          mono: TextStyle(
            fontFamily: 'FiraCode',
          ),
        )
      ),
      darkTheme: ThemeData.dark(
        // Mirror customizations for dark mode.
        colorScheme: darkColorScheme,
        radius: 0.25,
        scaling: 1.2,
        surfaceOpacity: 0.8,
        surfaceBlur: 10,
        typography: Typography.geist(
          sans: TextStyle(
            fontFamily: 'Inter',
          ),
          mono: TextStyle(
            fontFamily: 'FiraCode',
          ),
        )
      ),
      home: RobotMainView()
    );
  }
}
