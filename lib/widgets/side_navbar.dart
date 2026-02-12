import 'package:flutter/material.dart';
import 'package:perplexity_clone/theme/colors.dart';
import 'package:perplexity_clone/widgets/side_bar_buttons.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool _isCollapsed = true;

  void _toggleSidebar() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: _isCollapsed ? 64 : 200,
      color: AppColors.sideNav,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:
              _isCollapsed ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: _isCollapsed ? 2 : 10,
              ),
              child: Icon(
                Icons.auto_awesome_mosaic,
                color: AppColors.whiteColor,
                size: _isCollapsed ? 35 : 45,
              ),
            ),
            const SizedBox(height: 20),
            SideBarButtons(
              isCollapsed: _isCollapsed,
              icon: Icons.home_outlined,
              title: "Home",
            ),
            const SizedBox(height: 12),
            SideBarButtons(
              isCollapsed: _isCollapsed,
              icon: Icons.search,
              title: "Discover",
            ),
            const SizedBox(height: 12),
            SideBarButtons(
              isCollapsed: _isCollapsed,
              icon: Icons.library_books_outlined,
              title: "Library",
            ),
            const Spacer(), //push to bottom
            GestureDetector(
              onTap: _toggleSidebar,
              child: Icon(
                _isCollapsed
                    ? Icons.keyboard_arrow_right
                    : Icons.keyboard_arrow_left,
                color: AppColors.whiteColor,
                size: 25,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
