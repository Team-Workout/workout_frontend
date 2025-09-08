import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/notion_colors.dart';

class AppScaffoldWithNav extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const AppScaffoldWithNav({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/dashboard');
              break;
            case 1:
              context.go('/workout-record');
              break;
            case 2:
              context.go('/body-composition');
              break;
            case 3:
              context.go('/pt-main');
              break;
            case 4:
              context.go('/settings');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: NotionColors.white,
        selectedItemColor: NotionColors.black,
        unselectedItemColor: NotionColors.gray500,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_outlined),
            activeIcon: Icon(Icons.fitness_center),
            label: '운동',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: '체성분',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_outlined),
            activeIcon: Icon(Icons.person_add),
            label: 'PT',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }
}