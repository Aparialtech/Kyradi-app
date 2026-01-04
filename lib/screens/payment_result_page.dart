import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../widgets/gradient_button.dart';

class PaymentResultPage extends StatelessWidget {
  final bool success;
  final int amount;
  final String? paymentId;

  const PaymentResultPage({
    super.key,
    required this.success,
    required this.amount,
    this.paymentId,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final icon = success ? Icons.check_circle : Icons.error_outline;
    final title = success ? 'Ödeme Başarılı' : 'Ödeme Başarısız';
    final message = success ? loc.paymentSuccessMessage : loc.paymentFailedMessage;
    final color = success ? const Color(0xFF2E7D32) : theme.colorScheme.error;

    return Scaffold(
      appBar: AppBar(title: Text(loc.paymentPageTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 72, color: color),
              const SizedBox(height: 16),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '₺${amount.toString()}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              if ((paymentId ?? '').isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Payment ID: $paymentId',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              GradientButton(
                text: 'Ana sayfaya dön',
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home',
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
