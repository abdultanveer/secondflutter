import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ElectricityApp());
}

class ElectricityApp extends StatefulWidget {
  const ElectricityApp({super.key});

  @override
  State<ElectricityApp> createState() => _ElectricityAppState();
}

class _ElectricityAppState extends State<ElectricityApp> {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();

  bool isDarkMode = false;
  bool notificationsEnabled = true;
  int reminderDays = 3;
  String language = 'English';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  // LOAD PREFERENCES
  Future<void> loadPreferences() async {
    isDarkMode = await prefs.getBool('darkMode') ?? false;
    notificationsEnabled =
        await prefs.getBool('notifications') ?? true;
    reminderDays = await prefs.getInt('reminderDays') ?? 3;
    language = await prefs.getString('language') ?? 'English';

    setState(() {
      isLoading = false;
    });
  }

  // SAVE DARK MODE
  Future<void> saveDarkMode(bool value) async {
    setState(() {
      isDarkMode = value;
    });

    await prefs.setBool('darkMode', value);
  }

  // SAVE NOTIFICATIONS
  Future<void> saveNotifications(bool value) async {
    setState(() {
      notificationsEnabled = value;
    });

    await prefs.setBool('notifications', value);
  }

  // SAVE REMINDER DAYS
  Future<void> saveReminderDays(int value) async {
    setState(() {
      reminderDays = value;
    });

    await prefs.setInt('reminderDays', value);
  }

  // SAVE LANGUAGE
  Future<void> saveLanguage(String value) async {
    setState(() {
      language = value;
    });

    await prefs.setString('language', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Electricity Consumer',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
      ),

      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),

        body: isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : SettingsPage(
          isDarkMode: isDarkMode,
          notificationsEnabled: notificationsEnabled,
          reminderDays: reminderDays,
          language: language,
          onDarkModeChanged: saveDarkMode,
          onNotificationsChanged: saveNotifications,
          onReminderDaysChanged: saveReminderDays,
          onLanguageChanged: saveLanguage,
        ),
      ),
    );
  }
}

// SETTINGS PAGE

class SettingsPage extends StatelessWidget {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final int reminderDays;
  final String language;

  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<int> onReminderDaysChanged;
  final ValueChanged<String> onLanguageChanged;

  const SettingsPage({
    super.key,
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.reminderDays,
    required this.language,
    required this.onDarkModeChanged,
    required this.onNotificationsChanged,
    required this.onReminderDaysChanged,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [

        // ACCOUNT SETTINGS
        const ListTile(
          title: Text(
            'Account Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const ListTile(
          leading: Icon(Icons.person),
          title: Text('Consumer Name'),
          subtitle: Text('Rahul Kumar'),
        ),

        const ListTile(
          leading: Icon(Icons.numbers),
          title: Text('Consumer Number'),
          subtitle: Text('1234567890'),
        ),

        const Divider(),

        // APP PREFERENCES
        const ListTile(
          title: Text(
            'App Preferences',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // DARK MODE
        SwitchListTile(
          secondary: const Icon(Icons.dark_mode),
          title: const Text('Dark Mode'),
          subtitle: const Text('Enable dark theme'),
          value: isDarkMode,
          onChanged: onDarkModeChanged,
        ),

        // NOTIFICATIONS
        SwitchListTile(
          secondary: const Icon(Icons.notifications),
          title: const Text('Bill Notifications'),
          subtitle: const Text('Receive electricity bill notifications'),
          value: notificationsEnabled,
          onChanged: onNotificationsChanged,
        ),

        // REMINDER DAYS
        ListTile(
          leading: const Icon(Icons.calendar_month),
          title: const Text('Bill Reminder'),
          subtitle: const Text('Remind me before the due date'),
          trailing: DropdownButton<int>(
            value: reminderDays,
            items: const [
              DropdownMenuItem(
                value: 1,
                child: Text('1 day'),
              ),
              DropdownMenuItem(
                value: 3,
                child: Text('3 days'),
              ),
              DropdownMenuItem(
                value: 5,
                child: Text('5 days'),
              ),
              DropdownMenuItem(
                value: 7,
                child: Text('7 days'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                onReminderDaysChanged(value);
              }
            },
          ),
        ),

        // LANGUAGE
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          trailing: DropdownButton<String>(
            value: language,
            items: const [
              DropdownMenuItem(
                value: 'English',
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: 'Kannada',
                child: Text('Kannada'),
              ),
              DropdownMenuItem(
                value: 'Hindi',
                child: Text('Hindi'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                onLanguageChanged(value);
              }
            },
          ),
        ),

        const Divider(),

        // ABOUT
        const ListTile(
          title: Text(
            'About',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('App Version'),
          subtitle: Text('1.0.0'),
        ),

        const ListTile(
          leading: Icon(Icons.privacy_tip_outlined),
          title: Text('Privacy Policy'),
        ),
      ],
    );
  }
}