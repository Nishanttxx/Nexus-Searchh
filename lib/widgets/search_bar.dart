import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perplexity_clone/pages/chat_page.dart';
import 'package:perplexity_clone/services/chat_web_service.dart';
import 'package:perplexity_clone/theme/colors.dart';
import 'package:perplexity_clone/widgets/focus_menu.dart';
import 'package:perplexity_clone/widgets/search_bar_widgets.dart';

class SearchBarSection extends StatefulWidget {
  const SearchBarSection({super.key});

  @override
  State<SearchBarSection> createState() => _SearchBarSectionState();
}

class _SearchBarSectionState extends State<SearchBarSection> {
  final _queryController =
      TextEditingController(); //used to control  and read text from the text field
  final _focusNode = FocusNode();
  bool _isHovered = false;
  ConnectionStatus _connectionStatus = ConnectionStatus.disconnected;
  StreamSubscription? _connectionStatusSubscription;

  @override
  void initState() {
    super.initState();
    _connectionStatusSubscription = ChatWebService()
        .connectionStatusStream
        .listen((status) => setState(() => _connectionStatus = status));
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    //used to destroy everything once the work is over
    super.dispose();
    _queryController.dispose(); //used to free memeory used by queryController
    _connectionStatusSubscription?.cancel();
    _focusNode.dispose();
  }

  void _search() {
    ChatWebService().chat(_queryController.text
        .trim()); //sends the user typed text to the server,i.e. queryController.text is used to get what user typed in the text box and .trim() is used to remove or prevent the empty messages,.chat() is used to call the chat function and sends the message
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            ChatPage(question: _queryController.text.trim())));
  }

  Future<void> _pickFile() async {
    if (kDebugMode) {
      print("Attempting to pick a file...");
    }
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        if (kDebugMode) {
          print("File picked successfully: ${result.files.single.name}");
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File picked successfully')),
        );
      } else {
        if (kDebugMode) {
          print("File picking was canceled by the user.");
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File picking canceled')),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error picking file: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Where knowledge meets curiosity',
            style: GoogleFonts.ibmPlexMono(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w400,
              height: 1.2,
              letterSpacing: -0.5,
            )),
        const SizedBox(height: 32),
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 700,
            decoration: BoxDecoration(
              color: AppColors.searchBar,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _focusNode.hasFocus
                    ? Colors.white
                    : _isHovered
                        ? Colors.grey[600]!
                        : AppColors.searchBarBorder,
                width: _focusNode.hasFocus || _isHovered ? 2.0 : 1.5,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _queryController,
                    onSubmitted: (value) => _search(),
                    decoration: const InputDecoration(
                      hintText: 'Ask me anything...',
                      hintStyle: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const FocusMenu(),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: _pickFile,
                        behavior: HitTestBehavior.opaque,
                        child: const SearchBarWidgets(
                          icon: Icons.add_circle_outline,
                          text: 'Attach',
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _search(),
                        child: Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: AppColors.submitButton,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.arrow_forward,
                              color: AppColors.background),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildConnectionStatus(),
      ],
    );
  }

  Widget _buildConnectionStatus() {
    String text;
    Color color;
    switch (_connectionStatus) {
      case ConnectionStatus.connected:
        text = "Connected";
        color = Colors.green;
        break;
      case ConnectionStatus.connecting:
        text = "Connecting...";
        color = Colors.orange;
        break;
      case ConnectionStatus.disconnected:
        text = "Disconnected";
        color = Colors.red;
        break;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.circle, size: 10, color: color),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }
}
