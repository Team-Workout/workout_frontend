import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/body_composition_model.dart';

class BodyProfileSection extends StatelessWidget {
  final List<BodyComposition> compositions;

  const BodyProfileSection({
    Key? key,
    required this.compositions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (compositions.isEmpty) return const SizedBox.shrink();

    final latestData = compositions.first;
    final dateFormat = DateFormat('yyyy년 MM월 dd일');

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            child: Icon(Icons.person, size: 35, color: Colors.grey[600]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '회원 프로필',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1F36),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '최근 업데이트: ${dateFormat.format(DateTime.parse(latestData.measurementDate))}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}