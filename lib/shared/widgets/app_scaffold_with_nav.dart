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
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: NotionColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
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
            backgroundColor: Colors.transparent, // Container에서 배경색 설정
            elevation: 0, // 기본 그림자 제거
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
                icon: Icon(Icons.person_2_outlined),
                activeIcon: Icon(Icons.person_2),
                label: '마이',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
