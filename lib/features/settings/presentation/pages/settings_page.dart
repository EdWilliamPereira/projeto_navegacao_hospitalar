import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avoidStairsAsync = ref.watch(avoidStairsProvider);
    final highContrastAsync = ref.watch(highContrastProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed('map'),
        ),
      ),
      body: ListView(
        children: [
          // FR-07, FR-09 — accessible route preference
          SwitchListTile(
            title: const Text('Avoid stairs'),
            subtitle: const Text('Routes will use elevators and ramps only'),
            secondary: const Icon(Icons.accessible),
            value: avoidStairsAsync.value ?? false,
            // Disable toggle while preference is loading to prevent double-writes.
            onChanged: avoidStairsAsync.isLoading
                ? null
                : (_) => ref.read(avoidStairsProvider.notifier).toggle(),
          ),
          
          // FR-10 — high-contrast theme
          SwitchListTile(
            title: const Text('High contrast mode'),
            subtitle: const Text('Use high-contrast theme for accessibility'),
            secondary: const Icon(Icons.contrast),
            value: highContrastAsync.value ?? false,
            onChanged: highContrastAsync.isLoading
                ? null
                : (_) => ref.read(highContrastProvider.notifier).toggle(),
          ),

          const Divider(),
          const ListTile(
            title: Text('App version'),
            trailing: Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}
