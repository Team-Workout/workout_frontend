import 'package:flutter/material.dart';
import '../../../core/theme/notion_colors.dart';

class MemberDashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MemberDashboardAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: NotionColors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
          color: NotionColors.black,
        ),
      ],
    );
  }
}