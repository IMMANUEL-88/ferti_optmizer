import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agri_connect/constants/image_strings.dart';
import 'package:agri_connect/utils/appbar.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool emailAlerts = true;
  bool remoteMotorControl = true;
  bool notificationsEnabled = true;

  String userName = 'User';
  String userEmail = 'user@example.com';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      emailAlerts = prefs.getBool('emailAlerts') ?? true;
      remoteMotorControl = prefs.getBool('motorControl') ?? true;
      notificationsEnabled = prefs.getBool('notifications') ?? true;

      userName = prefs.getString('username') ?? 'User';
      userEmail = prefs.getString('email') ?? 'user@example.com';
    });
  }

  Future<void> _updatePreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required Function(bool) onChanged,
    IconData? icon,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Switch(
        activeColor: Colors.white,
        inactiveTrackColor: Colors.white54,
        value: value,
        onChanged: (newValue) {
          onChanged(newValue);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.green,
        appBar: const EAppBar(
          title: Text(
            "Settings",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: [
              const SizedBox(height: 10),

              // Profile container
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(EImages.user),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          userEmail,
                          style: const TextStyle(color: Colors.white54),
                        )
                      ],
                    ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(Iconsax.edit, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Switch options
              _buildSwitchTile(
                title: "Email Alerts",
                value: emailAlerts,
                icon: Iconsax.notification_status,
                onChanged: (val) {
                  setState(() => emailAlerts = val);
                  _updatePreference('emailAlerts', val);
                },
              ),
              _buildSwitchTile(
                title: "Remote Motor Control",
                value: remoteMotorControl,
                icon: Iconsax.camera,
                onChanged: (val) {
                  setState(() => remoteMotorControl = val);
                  _updatePreference('motorControl', val);
                },
              ),
              _buildSwitchTile(
                title: "Push Notifications",
                value: notificationsEnabled,
                icon: Iconsax.notification,
                onChanged: (val) {
                  setState(() => notificationsEnabled = val);
                  _updatePreference('notifications', val);
                },
              ),
              const SizedBox(height: 25),

              // Logout button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Iconsax.logout),
                  label: const Text("Logout"),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    context.go('/');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
