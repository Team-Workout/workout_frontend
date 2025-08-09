import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pt_service/features/profile/model/member_profile_model.dart';
import 'package:pt_service/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:intl/intl.dart';

class MemberProfileView extends ConsumerWidget {
  final String memberId;
  
  const MemberProfileView({super.key, required this.memberId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(memberProfileProvider(memberId));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원 프로필'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) => _buildProfile(context, profile),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('오류가 발생했습니다: $error'),
        ),
      ),
    );
  }
  
  Widget _buildProfile(BuildContext context, MemberProfile profile) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    profile.name.substring(0, 1),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  profile.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                if (profile.phoneNumber != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    profile.phoneNumber!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStat(context, '가입일', 
                      DateFormat('yyyy.MM.dd').format(profile.joinDate)),
                    const SizedBox(width: 32),
                    _buildStat(context, 'PT 수업', '${profile.totalSessions}회'),
                    const SizedBox(width: 32),
                    _buildStat(context, '이번달', '${profile.monthSessions}회'),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '체중 변화 추이',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                getDrawingHorizontalLine: (value) {
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
                                      const months = ['1월', '2월', '3월', '4월', '5월', '6월'];
                                      if (value.toInt() >= 0 && value.toInt() < months.length) {
                                        return Text(
                                          months[value.toInt()],
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
                                    interval: 5,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        '${value.toInt()}kg',
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
                              maxX: 5,
                              minY: 60,
                              maxY: 80,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: const [
                                    FlSpot(0, 75),
                                    FlSpot(1, 74.5),
                                    FlSpot(2, 73.8),
                                    FlSpot(3, 73.2),
                                    FlSpot(4, 72.5),
                                    FlSpot(5, 72),
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
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildWeightInfo(context, '시작 체중', '75.0kg'),
                            _buildWeightInfo(context, '현재 체중', '72.0kg'),
                            _buildWeightInfo(context, '목표 체중', '70.0kg'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                              '건강 정보',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text('수정'),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      _buildInfoTile(context, '생년월일', 
                        profile.birthDate != null 
                          ? DateFormat('yyyy년 MM월 dd일').format(profile.birthDate!)
                          : '미등록'),
                      const Divider(height: 1),
                      _buildInfoTile(context, '신장', 
                        profile.height != null ? '${profile.height}cm' : '미등록'),
                      const Divider(height: 1),
                      _buildInfoTile(context, '병력', 
                        profile.medicalHistory ?? '없음'),
                      const Divider(height: 1),
                      _buildInfoTile(context, '특이사항', 
                        profile.notes ?? '없음'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
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
                            {'date': '2024-01-15', 'type': '상체', 'duration': '60분'},
                            {'date': '2024-01-13', 'type': '하체', 'duration': '45분'},
                            {'date': '2024-01-11', 'type': '전신', 'duration': '90분'},
                          ];
                          final record = records[index];
                          
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Icon(
                                Icons.fitness_center,
                                color: Colors.blue.shade700,
                                size: 20,
                              ),
                            ),
                            title: Text('${record['type']} 운동'),
                            subtitle: Text(record['date']!),
                            trailing: Text(record['duration']!),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.message),
                        label: const Text('메시지'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          context.push('/pt-schedule');
                        },
                        icon: const Icon(Icons.calendar_month),
                        label: const Text('PT 예약'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStat(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Widget _buildWeightInfo(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
  
  Widget _buildInfoTile(BuildContext context, String label, String value) {
    return ListTile(
      title: Text(label),
      trailing: Text(
        value,
        style: TextStyle(
          color: value == '미등록' || value == '없음' 
            ? Colors.grey[600] 
            : null,
        ),
      ),
    );
  }
}