import 'package:flutter/material.dart';
import '../../utils/crash_log.dart';
import 'app_back_app_bar.dart';

class ErrorFallbackPage extends StatelessWidget {
  const ErrorFallbackPage({
    super.key,
    this.entry,
  });

  final CrashLogEntry? entry;

  @override
  Widget build(BuildContext context) {
    final timestamp = entry?.timestamp ?? DateTime.now();
    final code = entry?.id ?? timestamp.millisecondsSinceEpoch.toString();
    return Scaffold(
      appBar: buildBackAppBar(context),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Unexpected error',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Code: $code',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please restart the app.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  timestamp.toIso8601String(),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
