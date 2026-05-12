import 'package:flutter/material.dart';
import 'package:rui/screens/robot_view.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightColorScheme = ShadBlueColorScheme.light();
    final darkColorScheme = ShadBlueColorScheme.dark();
    return ShadApp.custom(
      theme: ShadThemeData(
        // Customize light mode colors and design tokens.
        colorScheme: lightColorScheme,
        separatorTheme: ShadSeparatorTheme(
          color: lightColorScheme.primary
        )
      ),
      darkTheme: ShadThemeData(
        // Mirror customizations for dark mode.
        colorScheme: darkColorScheme.copyWith(
          card: const Color.fromARGB(68, 48, 48, 48),
        ),
        separatorTheme: ShadSeparatorTheme(
          color: darkColorScheme.ring,
        )
      ),
      appBuilder: (context) {
        final shadTheme = Theme.of(context);
        final appTheme = shadTheme.copyWith(
          // Change material themes here.
        );
        return MaterialApp(
          theme: appTheme,
          localizationsDelegates: const [
            GlobalShadLocalizations.delegate,
          ],
          builder: (context, child) {
            return ShadAppBuilder(child: child!);
          },
          home: RobotMainView()
        );
      },
    );
  }
}
