import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/crash_log.dart';

class CrashLogPage extends StatelessWidget {
  const CrashLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = CrashLogBuffer.entries;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crash Logs'),
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
                      const SnackBar(content: Text('Logs copied')),
                    );
                  },
            icon: const Icon(Icons.copy_all_outlined),
          ),
        ],
      ),
      body: entries.isEmpty
          ? const Center(child: Text('No logs captured yet.'))
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
