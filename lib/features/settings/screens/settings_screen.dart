import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:soulchat/shared/providers/theme_provider.dart';
import 'package:soulchat/shared/providers/locale_provider.dart';
import 'package:soulchat/shared/providers/auth_provider.dart';
import 'package:soulchat/core/services/localization_service.dart';
import 'package:soulchat/core/services/self_check_service.dart';
import 'package:soulchat/core/services/system_architect_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _deepAgentLoading = false;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionTitle(context, 'Sistem Denetleyici'),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.robot),
            title: const Text('DeepAgent'),
            subtitle: const Text('Karmaşık sorunları analiz et (Gemini)'),
            trailing: _deepAgentLoading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _deepAgentLoading ? null : () => _runDeepAgent(context),
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.circleCheck),
            title: const Text('Self-Check durumu'),
            subtitle: Text(
              'Google: ${SelfCheckService.googleCloudOk ? "OK" : "Yedek"} | Firebase: ${SelfCheckService.firebaseOk ? "OK" : "Hata"} | Sohbet: Gemini',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const Divider(),
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
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ses efektleri yakında eklenecek.')),
            ),
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
            onTap: () => context.push('/about'),
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
            title: const Text('Logout'),
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () async {
              await ref.read(firebaseAuthServiceProvider).signOut();
              if (context.mounted) context.go('/login');
            },
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

  Future<void> _runDeepAgent(BuildContext context) async {
    setState(() => _deepAgentLoading = true);
    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (c) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('DeepAgent'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                'Yazıyor...',
                style: Theme.of(c).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
    try {
      final result = await SystemArchitectService.deepAgentAnalyze(
        'Uygulama genel durum kontrolü ve olası sorunların analizi.',
      );
      if (!context.mounted) return;
      Navigator.of(context).pop();
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('DeepAgent Analiz'),
          content: SingleChildScrollView(child: Text(result)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    } catch (_) {
      if (context.mounted) Navigator.of(context).pop();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bağlantı kurulamadı. İnternet bağlantınızı ve ayarları kontrol edip tekrar deneyin.')),
        );
      }
    } finally {
      if (mounted) setState(() => _deepAgentLoading = false);
    }
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
