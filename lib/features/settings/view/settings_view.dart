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
import '../../../services/image_cache_manager.dart';
import '../viewmodel/settings_viewmodel.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final profileImageAsync = ref.watch(profileImageProvider);

    return Scaffold(
      backgroundColor: NotionColors.gray50,
      appBar: AppBar(
        backgroundColor: NotionColors.white,
        title: const Text('설정', style: TextStyle(color: NotionColors.black)),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: NotionColors.white,
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Consumer(
                      builder: (context, ref, _) {
                        return profileImageAsync.when(
                          data: (profileImage) {
                            if (profileImage?.profileImageUrl != null && profileImage!.profileImageUrl.isNotEmpty) {
                              return _buildProfileImageAvatar(profileImage.profileImageUrl, user?.name);
                            } else {
                              return CircleAvatar(
                                radius: 40,
                                backgroundColor: NotionColors.black,
                                child: Text(
                                  user?.name.substring(0, 1) ?? 'U',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: NotionColors.white,
                                  ),
                                ),
                              );
                            }
                          },
                          loading: () => CircleAvatar(
                            radius: 40,
                            backgroundColor: NotionColors.black,
                            child: const CircularProgressIndicator(color: Colors.white),
                          ),
                          error: (_, __) => CircleAvatar(
                            radius: 40,
                            backgroundColor: NotionColors.black,
                            child: Text(
                              user?.name.substring(0, 1) ?? 'U',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: NotionColors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: NotionColors.black,
                          shape: BoxShape.circle,
                          border: Border.all(color: NotionColors.white, width: 1.5),
                        ),
                        child: IconButton(
                          iconSize: 14,
                          padding: EdgeInsets.zero,
                          onPressed: () => _showImagePickerOptions(context, ref),
                          icon: const Icon(Icons.camera_alt, color: NotionColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  user?.name ?? '사용자',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: NotionColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: NotionColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: NotionColors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _getUserTypeLabel(user?.userType.name),
                    style: const TextStyle(
                      color: NotionColors.white,
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
          _buildSection(
            context,
            '개발자 도구',
            [
              _buildSettingItem(
                context,
                Icons.sync,
                '마스터 데이터 동기화',
                () {
                  _performMasterDataSync(context, ref);
                },
              ),
              _buildSettingItem(
                context,
                Icons.clear_all,
                '캐시 초기화',
                () {
                  _clearMasterDataCache(context, ref);
                },
              ),
              Consumer(
                builder: (context, ref, _) {
                  final syncState = ref.watch(syncNotifierProvider);
                  return ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('동기화 상태'),
                    subtitle: Text(_getSyncStatusText(syncState)),
                    trailing: syncState.isLoading 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          syncState.isCompleted 
                            ? Icons.check_circle 
                            : syncState.error != null 
                              ? Icons.error 
                              : Icons.help_outline,
                          color: syncState.isCompleted 
                            ? NotionColors.black 
                            : syncState.error != null 
                              ? NotionColors.error 
                              : NotionColors.textSecondary,
                        ),
                  );
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () {
                _showLogoutDialog(context, ref);
              },
              icon: const Icon(Icons.logout, color: NotionColors.error),
              label: const Text(
                '로그아웃',
                style: TextStyle(color: NotionColors.error),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: NotionColors.error),
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
                  color: NotionColors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: NotionColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: NotionColors.border),
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
              backgroundColor: NotionColors.error,
            ),
            child: const Text('로그아웃'),
          ),
        ],
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
              ListTile(
                leading: const Icon(Icons.cancel, color: NotionColors.error),
                title: const Text(
                  '취소',
                  style: TextStyle(color: NotionColors.error),
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
        
        await ref.read(profileImageProvider.notifier).uploadProfileImage(pickedFile);
        
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
    _imageCache[fullImageUrl] ??= _loadProfileImageWithCache(fullImageUrl, cacheKey);
    
    return FutureBuilder<String?>(
      future: _imageCache[fullImageUrl],
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            radius: 40,
            backgroundColor: NotionColors.black,
            child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
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

        // 캐시가 없으면 기본 아바타 표시
        print('No cached profile image found, showing default avatar');
        return CircleAvatar(
          radius: 40,
          backgroundColor: NotionColors.black,
          child: Text(
            userName?.substring(0, 1) ?? 'U',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
          backgroundColor: NotionColors.black,
        ),
      );

      await ref.read(syncNotifierProvider.notifier).performSync();
      
      if (context.mounted) {
        final syncState = ref.read(syncNotifierProvider);
        
        if (syncState.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('동기화 실패: ${syncState.error}'),
              backgroundColor: NotionColors.error,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(syncState.message ?? '동기화가 완료되었습니다.'),
              backgroundColor: NotionColors.black,
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
            content: const Text('모든 마스터 데이터 캐시를 초기화하시겠습니까?\n다음 앱 실행 시 새로 동기화됩니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('초기화'),
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
              backgroundColor: NotionColors.black,
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

  Future<String?> _loadProfileImageWithCache(String fullImageUrl, String cacheKey) async {
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
}
