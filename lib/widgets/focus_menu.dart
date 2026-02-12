import 'package:flutter/material.dart';
import 'package:perplexity_clone/widgets/search_bar_widgets.dart';

class FocusMenu extends StatefulWidget {
  const FocusMenu({super.key});

  @override
  State<FocusMenu> createState() => _FocusMenuState();
}

class _FocusMenuState extends State<FocusMenu> {
  String _selectedItem = "All";

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) => setState(() => _selectedItem = value),
      itemBuilder: (context) => [
        const PopupMenuItem(value: "All", child: Text("All")),
        const PopupMenuItem(value: "Writing", child: Text("Writing")),
        const PopupMenuItem(value: "Academic", child: Text("Academic")),
        const PopupMenuItem(
            value: "Wolfram|Alpha", child: Text("Wolfram|Alpha")),
        const PopupMenuItem(value: "YouTube", child: Text("YouTube")),
        const PopupMenuItem(value: "Reddit", child: Text("Reddit")),
      ],
      child: SearchBarWidgets(
        icon: Icons.auto_awesome_outlined,
        text: _selectedItem,
      ),
    );
  }
}
