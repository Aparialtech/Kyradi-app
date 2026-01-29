import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../utils/crash_log.dart';

class CrashLogPage extends StatelessWidget {
  const CrashLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final entries = CrashLogBuffer.entries;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.crashLogsTitle),
        actions: [
          IconButton(
            onPressed: entries.isEmpty
                ? null
                : () async {
                    await Clipboard.setData(
                      ClipboardData(text: CrashLogBuffer.exportText()),
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(loc.crashLogsCopied)),
                    );
                  },
            icon: const Icon(Icons.copy_all_outlined),
          ),
        ],
      ),
      body: entries.isEmpty
          ? Center(child: Text(loc.crashLogsEmpty))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              separatorBuilder: (_, __) => const Divider(height: 20),
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Text(
                  entry.toLine(),
                  style: Theme.of(context).textTheme.bodySmall,
                );
              },
            ),
    );
  }
}
