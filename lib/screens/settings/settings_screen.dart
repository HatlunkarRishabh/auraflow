import 'package:auraflow/notifiers/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Settings"),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // --- Dark Mode Setting ---
              _buildDarkModeTile(context, themeNotifier),
              const Divider(),
              // --- Accent Color Setting ---
              _buildAccentColorTile(context, themeNotifier),
            ],
          ),
        );
      },
    );
  }

  /// Builds the list tile for the Dark Mode setting.
  Widget _buildDarkModeTile(BuildContext context, ThemeNotifier themeNotifier) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.dark_mode_outlined),
      title: const Text("Dark Mode"),
      trailing: Switch(
        value: themeNotifier.isDarkMode,
        onChanged: (value) {
          // No need for context.read, as we have the notifier instance here.
          themeNotifier.toggleTheme();
        },
      ),
    );
  }

  /// Builds the list tile for the Accent Color setting.
  Widget _buildAccentColorTile(BuildContext context, ThemeNotifier themeNotifier) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.color_lens_outlined),
      title: const Text("Accent Color"),
      trailing: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: themeNotifier.accentColor,
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
      ),
      onTap: () {
        _showColorPickerDialog(context, themeNotifier);
      },
    );
  }

  /// Shows the dialog for picking a new accent color.
  void _showColorPickerDialog(BuildContext context, ThemeNotifier themeNotifier) {
    Color pickerColor = themeNotifier.accentColor;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick an accent color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) => pickerColor = color,
              pickerAreaHeightPercent: 0.8,
              displayThumbColor: true,
              labelTypes: const [], // We don't need the hex/rgb/hsv labels
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                themeNotifier.setAccentColor(pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}