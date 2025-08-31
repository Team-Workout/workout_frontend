import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pt_service/core/providers/auth_provider.dart';
import 'package:pt_service/features/auth/model/user_model.dart';
import '../viewmodel/settings_viewmodel.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    user?.name.substring(0, 1) ?? 'U',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.name ?? '사용자',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _getUserTypeLabel(user?.userType.name),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            '계정 설정',
            [
              // 트레이너인 경우에만 프로필 수정 메뉴 표시
              if (user?.userType.name == 'trainer')
                _buildSettingItem(
                  context,
                  Icons.person,
                  '프로필 수정',
                  () {
                    context.push('/trainer-profile-edit');
                  },
                ),
              _buildSettingItem(
                context,
                Icons.lock,
                '비밀번호 변경',
                () {
                  _showChangePasswordDialog(context);
                },
              ),
              _buildSettingItem(
                context,
                Icons.phone,
                '연락처 수정',
                () {
                  _showChangePhoneDialog(context);
                },
              ),
            ],
          ),
          _buildSection(
            context,
            '개인정보 설정',
            [
              Consumer(
                builder: (context, ref, _) {
                  final workoutLogAccessAsync = ref.watch(workoutLogAccessProvider);
                  return workoutLogAccessAsync.when(
                    data: (isOpen) => _buildSwitchItem(
                      context,
                      Icons.visibility,
                      '운동일지 공개',
                      isOpen,
                      (value) {
                        ref.read(workoutLogAccessProvider.notifier).toggleWorkoutLogAccess(value);
                      },
                    ),
                    loading: () => ListTile(
                      leading: const Icon(Icons.visibility),
                      title: const Text('운동일지 공개'),
                      trailing: const CircularProgressIndicator(),
                    ),
                    error: (_, __) => _buildSwitchItem(
                      context,
                      Icons.visibility,
                      '운동일지 공개',
                      false,
                      (value) {
                        ref.read(workoutLogAccessProvider.notifier).toggleWorkoutLogAccess(value);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          _buildSection(
            context,
            '알림 설정',
            [
              _buildSwitchItem(
                context,
                Icons.notifications,
                'PT 일정 알림',
                true,
                (value) {},
              ),
              _buildSwitchItem(
                context,
                Icons.schedule,
                '운동 리마인더',
                true,
                (value) {},
              ),
              _buildSwitchItem(
                context,
                Icons.analytics,
                '주간 리포트',
                false,
                (value) {},
              ),
            ],
          ),
          _buildSection(
            context,
            '앱 설정',
            [
              _buildSettingItem(
                context,
                Icons.palette,
                '테마 설정',
                () {
                  _showThemeDialog(context);
                },
              ),
              _buildSettingItem(
                context,
                Icons.language,
                '언어 설정',
                () {
                  _showLanguageDialog(context);
                },
              ),
              _buildSettingItem(
                context,
                Icons.storage,
                '데이터 백업',
                () {
                  _showBackupDialog(context);
                },
              ),
            ],
          ),
          _buildSection(
            context,
            '기타',
            [
              _buildSettingItem(
                context,
                Icons.help,
                '도움말',
                () {
                  _showHelpDialog(context);
                },
              ),
              _buildSettingItem(
                context,
                Icons.info,
                '앱 정보',
                () {
                  _showAppInfoDialog(context);
                },
              ),
              _buildSettingItem(
                context,
                Icons.privacy_tip,
                '개인정보 처리방침',
                () {
                  _showPrivacyDialog(context);
                },
              ),
              _buildSettingItem(
                context,
                Icons.description,
                '이용약관',
                () {
                  _showTermsDialog(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () {
                _showLogoutDialog(context, ref);
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                '로그아웃',
                style: TextStyle(color: Colors.red),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _getUserTypeLabel(String? userType) {
    switch (userType) {
      case 'trainer':
        return '트레이너';
      case 'member':
        return '회원';
      case 'manager':
        return '관장';
      default:
        return '사용자';
    }
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: items,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(
    BuildContext context,
    IconData icon,
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('비밀번호 변경'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: '현재 비밀번호',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: '새 비밀번호',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: '새 비밀번호 확인',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('비밀번호가 변경되었습니다')),
              );
            },
            child: const Text('변경'),
          ),
        ],
      ),
    );
  }

  void _showChangePhoneDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('연락처 수정'),
        content: const TextField(
          decoration: InputDecoration(
            labelText: '새 연락처',
            hintText: '010-1234-5678',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('연락처가 수정되었습니다')),
              );
            },
            child: const Text('수정'),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('테마 선택'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('시스템 기본값'),
              value: 'system',
              groupValue: 'system',
              onChanged: (value) {},
            ),
            RadioListTile<String>(
              title: const Text('라이트 모드'),
              value: 'light',
              groupValue: 'system',
              onChanged: (value) {},
            ),
            RadioListTile<String>(
              title: const Text('다크 모드'),
              value: 'dark',
              groupValue: 'system',
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('적용'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('언어 선택'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('한국어'),
              value: 'ko',
              groupValue: 'ko',
              onChanged: (value) {},
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: 'ko',
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('적용'),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('데이터 백업'),
        content: const Text(
          '운동 기록과 설정을 클라우드에 백업합니다. '
          '백업된 데이터는 다른 기기에서 복원할 수 있습니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('백업이 완료되었습니다')),
              );
            },
            child: const Text('백업'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('도움말'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Q. PT 예약을 어떻게 하나요?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('A. 대시보드에서 "PT 예약" 버튼을 눌러 예약할 수 있습니다.'),
              SizedBox(height: 16),
              Text(
                'Q. 운동 기록은 어떻게 작성하나요?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('A. "운동 기록" 메뉴에서 "새 기록" 탭에서 작성할 수 있습니다.'),
              SizedBox(height: 16),
              Text(
                'Q. 비밀번호를 잊었어요.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('A. 로그인 화면에서 "비밀번호 찾기"를 이용해주세요.'),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('앱 정보'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('앱 이름: Workout - PT 관리 플랫폼'),
            SizedBox(height: 8),
            Text('버전: 1.0.0'),
            SizedBox(height: 8),
            Text('개발자: PT Service Team'),
            SizedBox(height: 8),
            Text('마지막 업데이트: 2024.01.15'),
            SizedBox(height: 16),
            Text('연락처: support@ptservice.com'),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('개인정보 처리방침'),
        content: const SingleChildScrollView(
          child: Text(
            '개인정보 처리방침\n\n'
            '1. 수집하는 개인정보\n'
            '- 이름, 이메일, 연락처\n'
            '- 운동 기록 및 건강 정보\n\n'
            '2. 이용 목적\n'
            '- PT 서비스 제공\n'
            '- 운동 기록 관리\n'
            '- 서비스 개선\n\n'
            '3. 보유 기간\n'
            '- 회원탈퇴 시까지\n\n'
            '자세한 내용은 웹사이트를 참조해주세요.',
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('이용약관'),
        content: const SingleChildScrollView(
          child: Text(
            '이용약관\n\n'
            '제1조 (목적)\n'
            '이 약관은 PT Service가 제공하는 모바일 애플리케이션 서비스의 '
            '이용에 관한 조건을 정하는 것을 목적으로 합니다.\n\n'
            '제2조 (서비스 이용)\n'
            '1. 서비스는 개인 PT 및 운동 기록 관리를 위해 사용되어야 합니다.\n'
            '2. 상업적 목적으로 사용을 금지합니다.\n\n'
            '제3조 (책임)\n'
            '서비스 이용에 따른 책임은 이용자에게 있습니다.\n\n'
            '자세한 내용은 웹사이트를 참조해주세요.',
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(authStateProvider).logout();
              context.go('/login');
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }
}
