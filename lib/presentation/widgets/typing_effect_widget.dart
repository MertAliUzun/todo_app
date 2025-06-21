import 'package:flutter/material.dart';

class TypingEffectWidget extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final VoidCallback? onComplete;

  const TypingEffectWidget({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 50),
    this.onComplete,
  });

  @override
  State<TypingEffectWidget> createState() => _TypingEffectWidgetState();
}

class _TypingEffectWidgetState extends State<TypingEffectWidget> {
  String _displayText = '';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    if (widget.text.isEmpty) {
      widget.onComplete?.call();
      return;
    }

    Future.delayed(widget.duration, () {
      if (mounted) {
        setState(() {
          if (_currentIndex < widget.text.length) {
            _displayText += widget.text[_currentIndex];
            _currentIndex++;
            _startTyping();
          } else {
            widget.onComplete?.call();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayText,
      style: widget.style,
    );
  }
} 