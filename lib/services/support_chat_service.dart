import '../utils/crash_log.dart';
import 'api_service.dart';

class SupportChatReply {
  const SupportChatReply({
    required this.ok,
    this.text,
    this.sessionId,
    this.error,
  });

  final bool ok;
  final String? text;
  final String? sessionId;
  final String? error;
}

class SupportChatService {
  const SupportChatService._();

  static Future<SupportChatReply> sendMessage({
    required String message,
    String? sessionId,
  }) async {
    appLog('support', 'SUPPORT_CHAT_SEND', level: AppLogLevel.info);
    final result = await ApiService.supportChat(
      message: message,
      sessionId: sessionId,
    );
    final ok = result['ok'] == true;
    final replyText = _extractReply(result);
    return SupportChatReply(
      ok: ok,
      text: replyText,
      sessionId: result['sessionId']?.toString() ??
          result['session']?.toString() ??
          sessionId,
      error: result['error']?.toString(),
    );
  }

  static String? _extractReply(Map<String, dynamic> result) {
    final direct = result['reply'] ?? result['message'];
    if (direct is String && direct.trim().isNotEmpty) return direct;
    final data = result['data'];
    if (data is Map<String, dynamic>) {
      final nested = data['reply'] ?? data['message'] ?? data['text'];
      if (nested is String && nested.trim().isNotEmpty) return nested;
    }
    return null;
  }
}
