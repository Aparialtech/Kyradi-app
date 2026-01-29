import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../services/support_chat_service.dart';

class SupportChatPage extends StatefulWidget {
  const SupportChatPage({super.key});

  @override
  State<SupportChatPage> createState() => _SupportChatPageState();
}

class _SupportChatPageState extends State<SupportChatPage> {
  final _messages = <_ChatMessage>[];
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  bool _isSending = false;
  bool _isTyping = false;
  String? _sessionId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_messages.isEmpty) {
      final loc = AppLocalizations.of(context)!;
      _messages.add(
        _ChatMessage.bot(text: loc.supportChatGreeting),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_isSending) return;
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _isSending = true;
      _messages.add(_ChatMessage.user(text: text));
      _textController.clear();
      _isTyping = true;
    });
    _scrollToEnd();
    final loc = AppLocalizations.of(context)!;
    try {
      final reply = await SupportChatService.sendMessage(
        message: text,
        sessionId: _sessionId,
      );
      final responseText = reply.text ?? _fallbackReply(text, loc);
      if (!mounted) return;
      setState(() {
        _sessionId = reply.sessionId ?? _sessionId;
        _messages.add(_ChatMessage.bot(text: responseText));
        _isTyping = false;
        _isSending = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMessage.bot(text: _fallbackReply(text, loc)));
        _isTyping = false;
        _isSending = false;
      });
    }
    _scrollToEnd();
  }

  String _fallbackReply(String input, AppLocalizations loc) {
    final text = input.toLowerCase();
    if (text.contains('iptal') || text.contains('cancel')) {
      return loc.supportChatHelpCancel;
    }
    if (text.contains('odeme') ||
        text.contains('ödeme') ||
        text.contains('kart') ||
        text.contains('payment')) {
      return loc.supportChatHelpPayment;
    }
    if (text.contains('rezervasyon') || text.contains('booking')) {
      return loc.supportChatHelpReservation;
    }
    if (text.contains('teslim') ||
        text.contains('pickup') ||
        text.contains('alım')) {
      return loc.supportChatHelpPickup;
    }
    if (text.contains('lokasyon') ||
        text.contains('konum') ||
        text.contains('location')) {
      return loc.supportChatHelpLocation;
    }
    if (text.contains('cuzdan') ||
        text.contains('cüzdan') ||
        text.contains('wallet') ||
        text.contains('kupon') ||
        text.contains('transfer')) {
      return loc.supportChatHelpWallet;
    }
    return loc.supportChatFallback;
  }

  void _scrollToEnd() {
    if (!_scrollController.hasClients) return;
    Future<void>.delayed(const Duration(milliseconds: 80), () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.supportChatTitle),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isTyping && index == _messages.length) {
                    return _ChatBubble(
                      message: _ChatMessage.bot(text: loc.supportChatTyping),
                      isTyping: true,
                    );
                  }
                  return _ChatBubble(message: _messages[index]);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: loc.supportChatHint,
                        filled: true,
                        fillColor:
                            theme.colorScheme.surfaceVariant.withOpacity(0.45),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 52,
                    width: 52,
                    child: ElevatedButton(
                      onPressed: _isSending ? null : _sendMessage,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: const CircleBorder(),
                      ),
                      child: Icon(
                        Icons.send_rounded,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.isUser,
  });

  final String text;
  final bool isUser;

  factory _ChatMessage.user({required String text}) =>
      _ChatMessage(text: text, isUser: true);

  factory _ChatMessage.bot({required String text}) =>
      _ChatMessage(text: text, isUser: false);
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.message,
    this.isTyping = false,
  });

  final _ChatMessage message;
  final bool isTyping;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alignment =
        message.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = message.isUser
        ? theme.colorScheme.primary
        : theme.colorScheme.surfaceVariant;
    final textColor = message.isUser
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;
    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(message.isUser ? 18 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: textColor,
            height: 1.3,
            fontStyle: isTyping ? FontStyle.italic : FontStyle.normal,
          ),
        ),
      ),
    );
  }
}
