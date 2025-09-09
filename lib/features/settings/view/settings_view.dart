import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pt_service/core/providers/auth_provider.dart';
import 'package:pt_service/features/auth/model/user_model.dart';
import 'package:pt_service/features/sync/viewmodel/sync_viewmodel.dart';
import 'package:pt_service/core/config/api_config.dart';
import 'package:pt_service/core/services/api_service.dart';
import '../../../core/theme/notion_colors.dart';
import '../../dashboard/widgets/notion_button.dart';
import '../../../services/image_cache_manager.dart';
import '../viewmodel/settings_viewmodel.dart';
import '../repository/settings_repository.dart';
import '../model/profile_image_model.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  final Map<String, Future<String?>> _imageCache = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileImageProvider.notifier).loadProfileImage();
      ref.read(privacySettingsProvider.notifier).loadPrivacySettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final profileImageAsync = ref.watch(profileImageProvider);
    
    // 트레이너인지 확인 (트레이너는 ShellRoute를 사용하지 않음)
    final isTrainer = user?.userType == UserType.trainer;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF10B981), Color(0xFF34D399), Color(0xFF6EE7B7)],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // 트레이너인 경우에만 뒤로가기 버튼 표시
        automaticallyImplyLeading: isTrainer,
        leading: isTrainer
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: const Text(
          '설정',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Consumer(
                      builder: (context, ref, _) {
                        // User 모델의 profileImageUrl을 직접 사용
                        if (user?.profileImageUrl != null && user!.profileImageUrl!.isNotEmpty) {
                          return _buildProfileImageAvatar(
                              '/images/${user.profileImageUrl}', user.name);
                        } else {
                          return _buildProfileImageAvatar(
                              '/images/default-profile.png', user?.name);
                        }
                      },
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: IconButton(
                          iconSize: 14,
                          padding: EdgeInsets.zero,
                          onPressed: () =>
                              _showImagePickerOptions(context, ref),
                          icon:
                              const Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  user?.name ?? '사용자',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF10B981),
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF34D399)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _getUserTypeLabel(user?.userType.name),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IBMPlexSansKR',
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
          // 트레이너가 아닌 경우에만 개인정보 공개 섹션 표시
          if (!isTrainer) ...[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "개인 정보 공개",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10B981),
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
            ),
            _buildPrivacySettingsSection(),
          ],
          const SizedBox(height: 20),
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
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showLogoutDialog(context, ref);
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  '로그아웃',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF10B981),
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF10B981).withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
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
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF34D399)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'IBMPlexSansKR',
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Color(0xFF10B981),
      ),
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
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF34D399)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'IBMPlexSansKR',
        ),
      ),
      trailing: Switch(
        value: value,
        activeColor: const Color(0xFF10B981),
        onChanged: onChanged,
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('비밀번호 변경'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: '현재 비밀번호',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF34D399),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF10B981),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: '새 비밀번호',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF34D399),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF10B981),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: '새 비밀번호 확인',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF34D399),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF10B981),
                    width: 2,
                  ),
                ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          '연락처 수정',
          style: TextStyle(
            fontFamily: 'IBMPlexSansKR',
            fontWeight: FontWeight.bold,
            color: Color(0xFF10B981),
          ),
        ),
        content: TextField(
          decoration: InputDecoration(
            labelText: '새 연락처',
            hintText: '010-1234-5678',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF34D399),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF10B981),
                width: 2,
              ),
            ),
          ),
          keyboardType: TextInputType.phone,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              '취소',
              style: TextStyle(
                fontFamily: 'IBMPlexSansKR',
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('연락처가 수정되었습니다'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '수숡',
              style: TextStyle(
                fontFamily: 'IBMPlexSansKR',
                fontWeight: FontWeight.w600,
              ),
            ),
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
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '적용',
              style: TextStyle(
                fontFamily: 'IBMPlexSansKR',
                fontWeight: FontWeight.w600,
              ),
            ),
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
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '적용',
              style: TextStyle(
                fontFamily: 'IBMPlexSansKR',
                fontWeight: FontWeight.w600,
              ),
            ),
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
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('백업이 완료되었습니다'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '백업',
              style: TextStyle(
                fontFamily: 'IBMPlexSansKR',
                fontWeight: FontWeight.w600,
              ),
            ),
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
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '닫기',
              style: TextStyle(
                fontFamily: 'IBMPlexSansKR',
                fontWeight: FontWeight.w600,
              ),
            ),
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
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '닫기',
              style: TextStyle(
                fontFamily: 'IBMPlexSansKR',
                fontWeight: FontWeight.w600,
              ),
            ),
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
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '닫기',
              style: TextStyle(
                fontFamily: 'IBMPlexSansKR',
                fontWeight: FontWeight.w600,
              ),
            ),
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
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '닫기',
              style: TextStyle(
                fontFamily: 'IBMPlexSansKR',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF10B981), Color(0xFF34D399)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 헤더 영역
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.logout_rounded,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '로그아웃',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '정말 로그아웃하시겠습니까?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'IBMPlexSansKR',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // 버튼 영역
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '취소',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ref.read(authStateProvider).logout();
                          context.go('/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '로그아웃',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '프로필 사진 변경',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('카메라로 촬영'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, ref);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('갤러리에서 선택'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, ref);
                },
              ),
              // 프로필 이미지가 있는 경우에만 삭제 옵션 표시
              Consumer(
                builder: (context, ref, _) {
                  final profileImageAsync = ref.watch(profileImageProvider);
                  return profileImageAsync.maybeWhen(
                    data: (profileImage) {
                      if (profileImage?.profileImageUrl != null &&
                          profileImage!.profileImageUrl.isNotEmpty) {
                        return ListTile(
                          leading: const Icon(Icons.delete, color: Colors.red),
                          title: const Text(
                            '프로필 사진 삭제',
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'IBMPlexSansKR',
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _showDeleteImageDialog(context);
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    orElse: () => const SizedBox.shrink(),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.grey),
                title: const Text(
                  '취소',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteImageDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFEF4444), Color(0xFFF87171)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 헤더 영역
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '프로필 사진 삭제',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '프로필 사진을 삭제하시겠습니까?\n삭제한 후에는 복구할 수 없습니다.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'IBMPlexSansKR',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // 버튼 영역
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '취소',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // 독립 함수 호출 - dialog와 완전 분리
                          _handleDeleteProfileImage();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '삭제',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteProfileImage(BuildContext context, WidgetRef ref) {
    if (!mounted) return;

    // 즉시 로딩 스낵바 표시
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('프로필 사진을 삭제 중입니다...')),
    );

    // 비동기 작업을 별도로 실행
    if (mounted) {
      ref.read(profileImageProvider.notifier).deleteProfileImage().then((_) {
        if (!mounted) return;

        // 이미지 캐시 클리어
        _imageCache.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('프로필 사진이 삭제되었습니다'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }).catchError((e) {
        if (!mounted) return;

        print('Profile image delete error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('프로필 사진 삭제에 실패했습니다: ${e.toString()}')),
        );
      });
    }
  }

  void _deleteProfileImageSafely(
      BuildContext context, ProfileImageNotifier notifier) {
    if (!mounted) return;

    // 즉시 로딩 스낵바 표시
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('프로필 사진을 삭제 중입니다...')),
    );

    // 비동기 작업을 별도로 실행 (ref 사용하지 않음)
    notifier.deleteProfileImage().then((_) {
      if (!mounted) return;

      // 이미지 캐시 클리어
      _imageCache.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('프로필 사진이 삭제되었습니다'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }).catchError((e) {
      if (!mounted) return;

      print('Profile image delete error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로필 사진 삭제에 실패했습니다: ${e.toString()}')),
      );
    });
  }

  Future<void> _pickImage(ImageSource source, WidgetRef ref) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('이미지를 업로드 중입니다...')),
          );
        }

        await ref
            .read(profileImageProvider.notifier)
            .uploadProfileImage(pickedFile);

        // 이미지 캐시 클리어
        _imageCache.clear();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('프로필 사진이 변경되었습니다')),
          );
        }
      }
    } catch (e) {
      print('Image picker error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('프로필 사진 변경에 실패했습니다: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _handleDeleteProfileImage() async {
    try {
      // 독립적인 함수로 모든 로직 처리
      await ref.read(profileImageProvider.notifier).deleteProfileImage();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('프로필 사진이 삭제되었습니다')),
        );
      }
    } catch (e) {
      print('Profile image delete error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('프로필 사진 삭제에 실패했습니다: ${e.toString()}')),
        );
      }
    }
  }

  Widget _buildProfileImageAvatar(String imageUrl, String? userName) {
    // 상대 경로인 경우 baseUrl을 붙여서 완전한 URL로 만들기
    String fullImageUrl = imageUrl;
    if (!imageUrl.startsWith('http')) {
      final baseUrl = ApiConfig.baseUrl.replaceAll('/api', '');
      fullImageUrl = '$baseUrl${imageUrl.startsWith('/') ? '' : '/'}$imageUrl';
    }

    print('Loading profile image from: $fullImageUrl');

    // 캐시 우선 로드 시도
    final cacheKey = imageUrl.hashCode.toString();

    // Future를 캐시해서 rebuild 시에도 재실행 방지
    _imageCache[fullImageUrl] ??=
        _loadProfileImageWithCache(fullImageUrl, cacheKey);

    return FutureBuilder<String?>(
      future: _imageCache[fullImageUrl],
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            radius: 40,
            backgroundColor: NotionColors.black,
            child: const CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          // 캐시된 파일이 있으면 File로 로드
          print('Loading profile image from cache: ${snapshot.data}');
          return CircleAvatar(
            radius: 40,
            backgroundImage: FileImage(File(snapshot.data!)),
            backgroundColor: NotionColors.gray200,
          );
        }

        // 캐시가 없으면 네트워크에서 이미지 로드 시도
        print('No cached profile image found, trying network: $fullImageUrl');
        return CircleAvatar(
          radius: 40,
          backgroundColor: NotionColors.gray200,
          child: ClipOval(
            child: Image.network(
              fullImageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // 네트워크 로드 실패 시 처리
                print('Network image load failed: $error');

                // 이미 default-profile.png인 경우 무한 루프 방지
                if (imageUrl.contains('default-profile.png')) {
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  );
                } else {
                  // default-profile.png로 재시도
                  return Image.network(
                    '${ApiConfig.baseUrl.replaceAll('/api', '')}/images/default-profile.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<Uint8List?> _loadAuthenticatedImage(String imageUrl) async {
    try {
      final dio = ref.read(dioProvider);
      print('Attempting to load image with authentication: $imageUrl');

      final response = await dio.get(
        imageUrl,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      print('Image loaded successfully, bytes: ${response.data.length}');
      return Uint8List.fromList(response.data);
    } catch (e) {
      print('Failed to load authenticated image: $e');

      // 인증 실패 시 일반 NetworkImage로 시도 (public 이미지일 가능성)
      try {
        final response = await HttpClient().getUrl(Uri.parse(imageUrl));
        final httpResponse = await response.close();
        if (httpResponse.statusCode == 200) {
          final bytes = await consolidateHttpClientResponseBytes(httpResponse);
          print('Image loaded via fallback method');
          return bytes;
        }
      } catch (fallbackError) {
        print('Fallback image loading also failed: $fallbackError');
      }

      return null;
    }
  }

  /// 마스터 데이터 동기화 수행
  void _performMasterDataSync(BuildContext context, WidgetRef ref) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('마스터 데이터 동기화를 시작합니다...'),
          backgroundColor: Color(0xFF10B981),
        ),
      );

      await ref.read(syncNotifierProvider.notifier).performSync();

      if (context.mounted) {
        final syncState = ref.read(syncNotifierProvider);

        if (syncState.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('동기화 실패: ${syncState.error}'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(syncState.message ?? '동기화가 완료되었습니다.'),
              backgroundColor: Color(0xFF10B981),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('동기화 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 마스터 데이터 캐시 초기화
  void _clearMasterDataCache(BuildContext context, WidgetRef ref) async {
    try {
      // 확인 다이얼로그 표시
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('캐시 초기화'),
            content:
                const Text('모든 마스터 데이터 캐시를 초기화하시겠습니까?\n다음 앱 실행 시 새로 동기화됩니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('취소'),
              ),
              NotionButton(
                text: '초기화',
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );

      if (confirmed == true) {
        await ref.read(syncNotifierProvider.notifier).clearCache();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('마스터 데이터 캐시가 초기화되었습니다.'),
              backgroundColor: Color(0xFF10B981),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('캐시 초기화 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 동기화 상태 텍스트 반환
  String _getSyncStatusText(SyncState syncState) {
    if (syncState.isLoading) {
      return '동기화 중...';
    } else if (syncState.error != null) {
      return '동기화 실패';
    } else if (syncState.isCompleted) {
      if (syncState.updatedCategories.isNotEmpty) {
        return '동기화 완료 (업데이트: ${syncState.updatedCategories.join(', ')})';
      } else {
        return '모든 데이터가 최신 버전';
      }
    } else {
      return '동기화 대기 중';
    }
  }

  Future<String?> _loadProfileImageWithCache(
      String fullImageUrl, String cacheKey) async {
    try {
      // 캐시 유효성 먼저 확인 (24시간)
      final hasValidCache = await ImageCacheManager().hasValidCache(
        cacheKey: cacheKey,
        type: ImageType.profile,
        maxAge: const Duration(hours: 24),
      );

      if (hasValidCache) {
        print('Using cached profile image');
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString('profile_image_$cacheKey');
      }

      // 캐시가 없거나 만료되었으면 새로 다운로드
      print('Cache expired or not found, downloading fresh profile image');
      return await ImageCacheManager().getCachedImage(
        imageUrl: fullImageUrl,
        cacheKey: cacheKey,
        type: ImageType.profile,
      );
    } catch (e) {
      print('Error loading profile image with cache: $e');
      return null;
    }
  }

  Widget _buildPrivacySettingsSection() {
    return Consumer(
      builder: (context, ref, _) {
        final privacySettingsAsync = ref.watch(privacySettingsProvider);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              privacySettingsAsync.when(
                data: (settings) => settings != null
                    ? Column(
                        children: [
                          _buildPrivacySwitchItem(
                            context,
                            Icons.fitness_center,
                            '운동 기록 공개',
                            '다른 사용자들이 나의 운동 기록을 볼 수 있습니다',
                            settings.isOpenWorkoutRecord,
                            (value) => ref
                                .read(privacySettingsProvider.notifier)
                                .toggleWorkoutRecord(value),
                          ),
                          _buildPrivacySwitchItem(
                            context,
                            Icons.photo_camera,
                            '바디 이미지 공개',
                            '다른 사용자들이 나의 바디 이미지를 볼 수 있습니다',
                            settings.isOpenBodyImg,
                            (value) => ref
                                .read(privacySettingsProvider.notifier)
                                .toggleBodyImg(value),
                          ),
                          _buildPrivacySwitchItem(
                            context,
                            Icons.analytics,
                            '인바디 정보 공개',
                            '다른 사용자들이 나의 인바디 정보를 볼 수 있습니다',
                            settings.isOpenBodyComposition,
                            (value) => ref
                                .read(privacySettingsProvider.notifier)
                                .toggleBodyComposition(value),
                          ),
                        ],
                      )
                    : _buildPrivacySettingsPlaceholder(),
                loading: () => privacySettingsAsync.hasValue
                    ? privacySettingsAsync.value != null
                        ? Column(
                            children: [
                              _buildPrivacySwitchItem(
                                context,
                                Icons.fitness_center,
                                '운동 기록 공개',
                                '다른 사용자들이 나의 운동 기록을 볼 수 있습니다',
                                privacySettingsAsync.value!.isOpenWorkoutRecord,
                                (value) => ref
                                    .read(privacySettingsProvider.notifier)
                                    .toggleWorkoutRecord(value),
                              ),
                              _buildPrivacySwitchItem(
                                context,
                                Icons.photo_camera,
                                '바디 이미지 공개',
                                '다른 사용자들이 나의 바디 이미지를 볼 수 있습니다',
                                privacySettingsAsync.value!.isOpenBodyImg,
                                (value) => ref
                                    .read(privacySettingsProvider.notifier)
                                    .toggleBodyImg(value),
                              ),
                              _buildPrivacySwitchItem(
                                context,
                                Icons.analytics,
                                '인바디 정보 공개',
                                '다른 사용자들이 나의 인바디 정보를 볼 수 있습니다',
                                privacySettingsAsync
                                    .value!.isOpenBodyComposition,
                                (value) => ref
                                    .read(privacySettingsProvider.notifier)
                                    .toggleBodyComposition(value),
                              ),
                            ],
                          )
                        : _buildPrivacySettingsPlaceholder()
                    : _buildPrivacySettingsPlaceholder(),
                error: (error, _) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    '설정을 불러올 수 없습니다: $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPrivacySettingsPlaceholder() {
    return Column(
      children: [
        _buildPrivacySwitchItemPlaceholder(Icons.fitness_center, '운동 기록 공개'),
        _buildPrivacySwitchItemPlaceholder(Icons.photo_camera, '바디 이미지 공개'),
        _buildPrivacySwitchItemPlaceholder(Icons.analytics, '인바디 정보 공개'),
      ],
    );
  }

  Widget _buildPrivacySwitchItemPlaceholder(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: Colors.grey,
              size: 18,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 12,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySwitchItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF10B981),
              size: 18,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFF10B981),
            activeThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
