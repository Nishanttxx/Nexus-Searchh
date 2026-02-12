import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perplexity_clone/theme/colors.dart';
import 'package:perplexity_clone/widgets/side_navbar.dart';
import 'package:perplexity_clone/widgets/sources.dart';
import 'package:perplexity_clone/widgets/answers.dart';

class ChatPage extends StatelessWidget {
  final String question;
  const ChatPage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left sidebar
          kIsWeb ? SideBar() : SizedBox(),
          kIsWeb ? const SizedBox(width: 100) : SizedBox(),

          // Main scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question
                  Text(
                    question,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sources section
                  Sources(),

                  const SizedBox(height: 24),

                  // Answer section (long content scrolls)
                  AnswerSection(),
                ],
              ),
            ),
          ),

          // Right spacer / placeholder
              kIsWeb
              ? Placeholder(
                  strokeWidth: 0,
                  color: AppColors.background,
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
