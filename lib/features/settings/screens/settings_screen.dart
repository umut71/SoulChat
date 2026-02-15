import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soulchat/shared/providers/theme_provider.dart';
import 'package:soulchat/shared/providers/locale_provider.dart';
import 'package:soulchat/core/services/localization_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionTitle(context, 'Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable dark theme'),
            value: themeMode == ThemeMode.dark,
            onChanged: (value) {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
            secondary: const FaIcon(FontAwesomeIcons.moon),
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.language),
            title: const Text('Language'),
            subtitle: Text(LocalizationService.getLanguageName(locale.languageCode)['name']!),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showLanguageDialog(context, ref),
          ),
          const Divider(),
          _buildSectionTitle(context, 'Audio'),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.microphone),
            title: const Text('Voice Effects'),
            subtitle: const Text('Choose your voice effect'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(),
          _buildSectionTitle(context, 'Privacy'),
          SwitchListTile(
            title: const Text('Online Status'),
            subtitle: const Text('Show when you are online'),
            value: true,
            onChanged: (value) {},
            secondary: const FaIcon(FontAwesomeIcons.eye),
          ),
          SwitchListTile(
            title: const Text('Read Receipts'),
            subtitle: const Text('Show when you read messages'),
            value: true,
            onChanged: (value) {},
            secondary: const FaIcon(FontAwesomeIcons.checkDouble),
          ),
          const Divider(),
          _buildSectionTitle(context, 'Notifications'),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive notifications'),
            value: true,
            onChanged: (value) {},
            secondary: const FaIcon(FontAwesomeIcons.bell),
          ),
          const Divider(),
          _buildSectionTitle(context, 'Account'),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.circleInfo),
            title: const Text('About'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
            title: const Text('Logout'),
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: LocalizationService.supportedLocales.length,
            itemBuilder: (context, index) {
              final locale = LocalizationService.supportedLocales[index];
              final languageInfo = LocalizationService.getLanguageName(locale.languageCode);
              return ListTile(
                title: Text(languageInfo['name']!),
                onTap: () {
                  ref.read(localeProvider.notifier).setLocale(locale);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
