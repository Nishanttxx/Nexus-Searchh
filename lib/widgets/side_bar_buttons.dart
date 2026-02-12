import 'package:flutter/material.dart';
import 'package:perplexity_clone/theme/colors.dart';

class SideBarButtons extends StatefulWidget {
  final bool isCollapsed;
  final IconData icon;
  final String title;

  const SideBarButtons(
      {super.key,
      required this.isCollapsed,
      required this.icon,
      required this.title});

  @override
  State<SideBarButtons> createState() => _SideBarButtonsState();
}

class _SideBarButtonsState extends State<SideBarButtons> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.grey[800] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
            mainAxisAlignment: widget.isCollapsed
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(widget.icon, color: AppColors.whiteColor, size: 24),
              if (!widget.isCollapsed)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(widget.title,
                      style: const TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ),
            ]),
      ),
    );
  }
}
