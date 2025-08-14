// lib/main.dart
import 'package:auraflow/models/goal.dart';
import 'package:auraflow/models/sticky_note.dart';
import 'package:auraflow/models/task.dart';
import 'package:auraflow/models/task_priority.dart';
import 'package:auraflow/screens/main_shell.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'notifiers/goal_notifier.dart';
import 'notifiers/sticky_note_notifier.dart';
import 'notifiers/theme_notifier.dart';
import 'theme/app_theme.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(GoalAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(SubTaskAdapter());
  Hive.registerAdapter(StickyNoteAdapter());
  Hive.registerAdapter(TaskPriorityAdapter());

  await Hive.openBox<Goal>('goals');
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<SubTask>('subtasks');
  await Hive.openBox<StickyNote>('stickynotes');

  runApp(const AuraFlowApp());
}

class AuraFlowApp extends StatelessWidget {
  const AuraFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider allows us to provide multiple objects to the widgets below.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
        ChangeNotifierProvider(create: (context) => GoalNotifier()),
        ChangeNotifierProvider(create: (context) => StickyNoteNotifier()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'AuraFlow',
            debugShowCheckedModeBanner: false,
            theme: AuraFlowTheme.light(themeNotifier.accentColor),
            darkTheme: AuraFlowTheme.dark(themeNotifier.accentColor),
            themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const MainShell(), 
          );
        },
      ),
    );
  }
}