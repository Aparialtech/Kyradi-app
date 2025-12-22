import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/api_service.dart';

class ApiSettingsOutcome {
  const ApiSettingsOutcome({required this.changed, required this.message});

  final bool changed;
  final String message;
}

Future<ApiSettingsOutcome?> showApiSettingsDialog(BuildContext context) async {
  await ApiService.ensureInitialized();
  if (!context.mounted) return null;
  const resetSentinel = '__reset_api_base__';
  final loc = AppLocalizations.of(context)!;

  final isEnvLocked = ApiService.baseUrlSource == 'environment';
  final controller = TextEditingController(
    text: ApiService.customBaseUrl ?? ApiService.baseUrl,
  );

  String? errorText;

  final result = await showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (stateContext, setDialogState) {
          final theme = Theme.of(stateContext);
          return AlertDialog(
            title: Text(loc.apiSettingsTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  enableSuggestions: false,
                  textInputAction: TextInputAction.done,
                  readOnly: isEnvLocked,
                  decoration: InputDecoration(
                    labelText: loc.apiSettingsBaseUrlLabel,
                    hintText:
                        'https://sharon-confidential-augustus.ngrok-free.de',
                    errorText: errorText,
                  ),
                  onSubmitted: (_) => Navigator.of(stateContext).pop(),
                ),
                const SizedBox(height: 12),
                Text(
                  loc.apiSettingsActiveLabel(
                    ApiService.baseUrl.isNotEmpty ? ApiService.baseUrl : '-',
                  ),
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  isEnvLocked
                      ? loc.apiSettingsEnvLockedNote
                      : loc.apiSettingsDeviceNote,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
            actions: [
              if (ApiService.hasCustomBaseUrl && !isEnvLocked)
                TextButton(
                  onPressed: () =>
                      Navigator.of(stateContext).pop(resetSentinel),
                  child: Text(loc.apiSettingsResetButton),
                ),
              TextButton(
                onPressed: () => Navigator.of(stateContext).pop(),
                child: Text(loc.dialogDismiss),
              ),
              if (!isEnvLocked)
                FilledButton(
                  onPressed: () {
                    final normalized = ApiService.normalizeBaseUrl(
                      controller.text,
                    );
                    if (normalized == null) {
                      setDialogState(() {
                        errorText = loc.apiSettingsInvalidUrl;
                      });
                      return;
                    }
                    Navigator.of(stateContext).pop(normalized);
                  },
                  child: Text(loc.save),
                ),
            ],
          );
        },
      );
    },
  );

  if (result == null) return null;
  if (result == resetSentinel) {
    await ApiService.clearCustomBaseUrl();
    return ApiSettingsOutcome(
      changed: true,
      message: loc.apiSettingsResetSuccess,
    );
  }

  await ApiService.setCustomBaseUrl(result);
  return ApiSettingsOutcome(
    changed: true,
    message: loc.apiSettingsUpdatedSuccess,
  );
}
