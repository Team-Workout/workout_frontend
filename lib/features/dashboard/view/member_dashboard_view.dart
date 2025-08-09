import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pt_service/core/providers/auth_provider.dart';
import 'package:pt_service/shared/widgets/dashboard_card.dart';

class MemberDashboardView extends ConsumerWidget {
  const MemberDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 운동 관리'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.push('/settings');
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context, ref),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '안녕하세요, ${user?.name ?? '회원'}님!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '오늘도 건강한 하루 보내세요!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                DashboardCard(
                  title: '이번 주 운동',
                  value: '3/5회',
                  icon: Icons.fitness_center,
                  color: Colors.blue,
                  onTap: () {
                    context.push('/workout-record');
                  },
                ),
                DashboardCard(
                  title: '다음 PT',
                  value: '내일 14:00',
                  icon: Icons.calendar_today,
                  color: Colors.green,
                  onTap: () {
                    context.push('/pt-schedule');
                  },
                ),
                DashboardCard(
                  title: '이번 달 목표',
                  value: '70% 달성',
                  icon: Icons.flag,
                  color: Colors.orange,
                  onTap: () {},
                ),
                DashboardCard(
                  title: '체중 변화',
                  value: '-2.5kg',
                  icon: Icons.trending_down,
                  color: Colors.purple,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '주간 운동 현황',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey.shade300,
                                strokeWidth: 1,
                              );
                            },
                            getDrawingVerticalLine: (value) {
                              return FlLine(
                                color: Colors.grey.shade300,
                                strokeWidth: 1,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  const days = ['월', '화', '수', '목', '금', '토', '일'];
                                  if (value.toInt() >= 0 && value.toInt() < days.length) {
                                    return Text(
                                      days[value.toInt()],
                                      style: const TextStyle(fontSize: 12),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 30,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toInt()}분',
                                    style: const TextStyle(fontSize: 10),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          minX: 0,
                          maxX: 6,
                          minY: 0,
                          maxY: 120,
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 60),
                                FlSpot(1, 80),
                                FlSpot(2, 0),
                                FlSpot(3, 90),
                                FlSpot(4, 70),
                                FlSpot(5, 0),
                                FlSpot(6, 0),
                              ],
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 3,
                              dotData: const FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.blue.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '최근 운동 기록',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            context.push('/workout-record');
                          },
                          child: const Text('전체보기'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final records = [
                        {
                          'date': '2024-01-15',
                          'type': '상체 운동',
                          'duration': '60분',
                          'trainer': '김트레이너'
                        },
                        {
                          'date': '2024-01-13',
                          'type': '하체 운동',
                          'duration': '45분',
                          'trainer': '김트레이너'
                        },
                        {
                          'date': '2024-01-11',
                          'type': '전신 운동',
                          'duration': '90분',
                          'trainer': '김트레이너'
                        },
                      ];
                      final record = records[index];
                      
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(
                            Icons.fitness_center,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        title: Text(record['type']!),
                        subtitle: Text('${record['date']} • ${record['trainer']}'),
                        trailing: Text(
                          record['duration']!,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          context.push('/workout-record');
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.push('/workout-record');
              },
              icon: const Icon(Icons.add),
              label: const Text('운동 기록 추가'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDrawer(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 30),
                ),
                const SizedBox(height: 12),
                Text(
                  ref.watch(currentUserProvider)?.name ?? '회원',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ref.watch(currentUserProvider)?.email ?? '',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('대시보드'),
            selected: true,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text('운동 기록'),
            onTap: () {
              Navigator.pop(context);
              context.push('/workout-record');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('PT 일정'),
            onTap: () {
              Navigator.pop(context);
              context.push('/pt-schedule');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('내 프로필'),
            onTap: () {
              Navigator.pop(context);
              context.push('/member-profile/${ref.read(currentUserProvider)?.id}');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('설정'),
            onTap: () {
              Navigator.pop(context);
              context.push('/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('로그아웃'),
            onTap: () {
              ref.read(authStateProvider).logout();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}