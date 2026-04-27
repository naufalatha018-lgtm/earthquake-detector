import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/providers/settings_provider.dart';
import '../../core/theme/app_style.dart';

class SystemPage extends StatelessWidget {
  const SystemPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(settings.getString('system_prefs')),
        leading: const BackButton(),
      ),
      backgroundColor: AppStyle.bg(context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              title: settings.getString('theme'),
              child: DropdownButtonFormField<String>(
                value: settings.themeName,
                items: ["Light", "Dark", "System"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => settings.setThemeMode(value!),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppStyle.card(context).color,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              title: settings.getString('language'),
              child: DropdownButtonFormField<String>(
                value: settings.languageName,
                items: ["English", "Indonesia"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => settings.setLanguage(value!),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppStyle.card(context).color,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
