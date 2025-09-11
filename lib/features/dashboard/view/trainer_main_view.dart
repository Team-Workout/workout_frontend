import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'trainer_dashboard_view.dart';
import '../../pt/view/trainer_pt_main_view.dart';
import '../../reservation/view/trainer_reservation_main_view.dart';
import '../../settings/view/trainer_settings_view.dart';

class TrainerMainView extends ConsumerStatefulWidget {
  final Widget? child; // ShellRoute에서 전달받을 자식 위젯
  
  const TrainerMainView({super.key, this.child});

  @override
  ConsumerState<TrainerMainView> createState() => _TrainerMainViewState();
}

class _TrainerMainViewState extends ConsumerState<TrainerMainView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const TrainerDashboardView(),
    const TrainerPTMainView(),
    const TrainerReservationMainView(),
    const TrainerSettingsView(),
  ];

  void _onItemTapped(int index) {
    if (widget.child != null) {
      // ShellRoute 모드일 때는 라우터로 이동
      switch (index) {
        case 0:
          context.go('/trainer-dashboard');
          break;
        case 1:
          context.go('/trainer-pt-main');
          break;
        case 2:
          context.go('/trainer-reservation-main');
          break;
        case 3:
          context.go('/trainer-settings');
          break;
      }
    } else {
      // 기존 IndexedStack 모드
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  int _getCurrentIndex(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    
    if (currentLocation == '/trainer-dashboard') return 0;
    else if (currentLocation.startsWith('/trainer-pt') || currentLocation == '/pt-applications' || currentLocation == '/pt-offerings') return 1;
    else if (currentLocation.startsWith('/trainer-reservation') || currentLocation == '/pt-schedule') return 2;
    else if (currentLocation == '/trainer-settings') return 3;
    
    return _selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = widget.child != null ? _getCurrentIndex(context) : _selectedIndex;
    
    return Scaffold(
      body: widget.child ?? IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: '홈',
                  index: 0,
                  isSelected: currentIndex == 0,
                ),
                _buildNavItem(
                  icon: Icons.fitness_center_outlined,
                  activeIcon: Icons.fitness_center,
                  label: 'PT',
                  index: 1,
                  isSelected: currentIndex == 1,
                ),
                _buildNavItem(
                  icon: Icons.calendar_month_outlined,
                  activeIcon: Icons.calendar_month,
                  label: '예약',
                  index: 2,
                  isSelected: currentIndex == 2,
                ),
                _buildNavItem(
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings,
                  label: '마이',
                  index: 3,
                  isSelected: currentIndex == 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    bool? isSelected,
  }) {
    final selected = isSelected ?? (_selectedIndex == index);
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF10B981).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? activeIcon : icon,
              color: selected ? const Color(0xFF10B981) : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? const Color(0xFF10B981) : Colors.grey[600],
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
