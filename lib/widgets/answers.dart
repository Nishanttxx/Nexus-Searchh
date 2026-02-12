import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:perplexity_clone/services/chat_web_service.dart';
import 'package:perplexity_clone/theme/colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AnswerSection extends StatefulWidget {
  const AnswerSection({super.key});

  @override
  State<AnswerSection> createState() => _AnswerSectionState();
}

class _AnswerSectionState extends State<AnswerSection> {
  StreamSubscription? _contentSubscription;
  Timer? _animationTimer;

  bool _isLoading = true;
  // The full response received from the server so far.
  String _fullResponse = '';
  // The part of the response that is currently displayed on screen.
  String _displayedResponse = '';
  // The index of the next character to be displayed.
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();
    _contentSubscription = ChatWebService().contentStream.listen((data) {
      if (_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
      _fullResponse += data['data'];
      _startAnimationIfNeeded();
    });
  }

  void _startAnimationIfNeeded() {
    // Start the timer only if it's not already running.
    if (_animationTimer?.isActive ?? false) return;

    _animationTimer = Timer.periodic(const Duration(milliseconds: 15), (timer) {
      // If all characters of the current fullResponse are displayed
      if (_charIndex >= _fullResponse.length) {
        timer.cancel(); // Stop the timer
      } else {
        // Append one character at a time.
        _displayedResponse += _fullResponse[_charIndex];
        _charIndex++;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _contentSubscription?.cancel();
    _animationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Perplexity',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Skeletonizer(
          enabled: _isLoading,
          child: Markdown(
            data: _isLoading ? 'Loading...' : _displayedResponse,
            shrinkWrap: true,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              codeblockDecoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              code: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
