import 'package:flutter/material.dart';
import 'app_back_app_bar.dart';

class ConfigMissingPage extends StatelessWidget {
  const ConfigMissingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBackAppBar(context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_outlined, size: 48),
              const SizedBox(height: 12),
              Text(
                'Uygulama kurulumu eksik',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Bu sürüm yanlış yapılandırılmış. Lütfen uygulamayı yeniden yükleyin.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
