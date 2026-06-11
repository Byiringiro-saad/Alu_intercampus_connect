import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/app_routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Edit Profile'),
            subtitle: const Text('Update photo, name, program, and interests'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle between light and dark themes'),
            value: theme.isDarkMode,
            onChanged: (_) => theme.toggleTheme(),
            secondary: Icon(
              theme.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Account'),
            subtitle: Text(auth.user?.email ?? ''),
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: const Text('Program'),
            subtitle: Text(auth.user?.program ?? ''),
          ),
          ListTile(
            leading: const Icon(Icons.location_city_outlined),
            title: const Text('Campus'),
            subtitle: Text(auth.user?.campus ?? ''),
          ),
        ],
      ),
    );
  }
}
