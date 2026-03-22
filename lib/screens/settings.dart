import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool autoAudioPlay = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Auto Play Audio Reading'),
            subtitle: const Text('Automatically start reading when opening a story'),
            value: autoAudioPlay,
            activeColor: const Color(0xFF6B52D9),
            onChanged: (val) {
              setState(() => autoAudioPlay = val);
              // TODO: Save this to SharedPreferences for backend
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Account Details'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
