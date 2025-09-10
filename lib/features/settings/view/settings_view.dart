import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pt_service/core/providers/auth_provider.dart';
import 'package:pt_service/features/auth/model/user_model.dart';
import 'package:pt_service/features/sync/viewmodel/sync_viewmodel.dart';
import 'package:pt_service/core/config/api_config.dart';
import '../../dashboard/widgets/notion_button.dart';
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
      ref.read(privacySettingsProvider.notifier).loadPrivacySettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    // 트레이너인지 확인 (트레이너는 앱바 유지, 멤버는 앱바 제거)
    final isTrainer = user?.userType == UserType.trainer;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: isTrainer
          ? AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF10B981),
                      Color(0xFF34D399),
                      Color(0xFF6EE7B7)
                    ],
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
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
            )
          : null,
      body: isTrainer
          ? ListView(children: [
              _buildMainContent(),
            ])
          : SafeArea(
              child: ListView(
                children: [
                  _buildMainContent(),
                ],
              ),
            ),
    );
  }

  Widget _buildMainContent() {
    final user = ref.watch(currentUserProvider);
    final profileImageAsync = ref.watch(profileImageProvider);
    final isTrainer = user?.userType == UserType.trainer;

    return Column(
      children: [
        // 프로필 섹션
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // 프로필 이미지
              Stack(
                children: [
                  profileImageAsync.when(
                    data: (profileImage) {
                      if (profileImage?.profileImageUrl != null &&
                          profileImage!.profileImageUrl.isNotEmpty) {
                        return _buildProfileImageAvatar(
                          profileImage.profileImageUrl,
                          user?.name,
                        );
                      }
                      return CircleAvatar(
                        radius: 40,
                        backgroundColor: const Color(0xFF10B981),
                        child: Text(
                          user?.name?.substring(0, 1).toUpperCase() ?? 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    loading: () => const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    error: (_, __) => CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color(0xFF10B981),
                      child: Text(
                        user?.name?.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // 카메라 버튼
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _showImagePickerOptions(context, ref),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 사용자 정보
              Text(
                user?.name ?? '사용자',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getUserTypeLabel(user?.userType.toString()),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 개인정보 공개 설정 (멤버만)
        if (!isTrainer) ...[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    '개인정보 공개 설정',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
                _buildPrivacySettingsSection(),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],

        // 일반 설정
        _buildSection(
          context,
          '일반',
          [
            _buildSettingItem(
              Icons.sync,
              '마스터 데이터 동기화',
              '운동 데이터를 서버와 동기화합니다',
              () => _performMasterDataSync(context, ref),
            ),
            _buildSettingItem(
              Icons.clear_all,
              '데이터 캐시 초기화',
              '저장된 캐시 데이터를 모두 삭제합니다',
              () => _clearMasterDataCache(context, ref),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 정보
        _buildSection(
          context,
          '정보',
          [
            _buildSettingItem(
              Icons.privacy_tip,
              '개인정보 처리방침',
              '개인정보 보호정책을 확인합니다',
              () => _showPrivacyDialog(context),
            ),
            _buildSettingItem(
              Icons.description,
              '이용약관',
              '서비스 이용약관을 확인합니다',
              () => _showTermsDialog(context),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 로그아웃 버튼
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: OutlinedButton(
            onPressed: () => _showLogoutDialog(context, ref),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, size: 20),
                SizedBox(width: 8),
                Text(
                  '로그아웃',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingItem(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF10B981)),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'IBMPlexSansKR',
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontFamily: 'IBMPlexSansKR',
          color: Colors.grey[600],
        ),
      ),
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right),
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

  Widget _buildPrivacySettingsSection() {
    return Consumer(
      builder: (context, ref, _) {
        final privacySettingsAsync = ref.watch(privacySettingsProvider);

        return privacySettingsAsync.when(
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
          loading: () => _buildPrivacySettingsPlaceholder(),
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              '설정을 불러올 수 없습니다: $error',
              style: const TextStyle(color: Colors.red),
            ),
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
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
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

  Widget _buildProfileImageAvatar(String imageUrl, String? userName) {
    String fullImageUrl = imageUrl;
    if (!imageUrl.startsWith('http')) {
      final baseUrl = ApiConfig.baseUrl.replaceAll('/api', '');
      fullImageUrl = '$baseUrl${imageUrl.startsWith('/') ? '' : '/'}$imageUrl';
    }

    final cacheKey = imageUrl.hashCode.toString();
    _imageCache[fullImageUrl] ??=
        _loadProfileImageWithCache(fullImageUrl, cacheKey);

    return FutureBuilder<String?>(
      future: _imageCache[fullImageUrl],
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xFF10B981),
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return CircleAvatar(
            radius: 40,
            backgroundImage: FileImage(File(snapshot.data!)),
            backgroundColor: Colors.grey[200],
          );
        }

        return CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[200],
          child: ClipOval(
            child: Image.network(
              fullImageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFF10B981),
                  child: Text(
                    userName?.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const CircularProgressIndicator(
                  color: Color(0xFF10B981),
                  strokeWidth: 2,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<String?> _loadProfileImageWithCache(
      String fullImageUrl, String cacheKey) async {
    try {
      final hasValidCache = await ImageCacheManager().hasValidCache(
        cacheKey: cacheKey,
        type: ImageType.profile,
        maxAge: const Duration(hours: 24),
      );

      if (hasValidCache) {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString('profile_image_$cacheKey');
      }

      return await ImageCacheManager().getCachedImage(
        imageUrl: fullImageUrl,
        cacheKey: cacheKey,
        type: ImageType.profile,
      );
    } catch (e) {
      return null;
    }
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
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _showDeleteImageDialog(context, ref);
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
                title: const Text('취소', style: TextStyle(color: Colors.grey)),
                onTap: () => Navigator.pop(context),
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

        await ref
            .read(profileImageProvider.notifier)
            .uploadProfileImage(pickedFile);
        _imageCache.clear();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('프로필 사진이 변경되었습니다')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('프로필 사진 변경에 실패했습니다: ${e.toString()}')),
        );
      }
    }
  }

  void _showDeleteImageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '프로필 사진을 삭제하시겠습니까?\n삭제한 후에는 복구할 수 없습니다.',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
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
                        child: const Text('취소'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _handleDeleteProfileImage(ref);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                        ),
                        child: const Text('삭제'),
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

  Future<void> _handleDeleteProfileImage(WidgetRef ref) async {
    try {
      await ref.read(profileImageProvider.notifier).deleteProfileImage();
      _imageCache.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('프로필 사진이 삭제되었습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('프로필 사진 삭제에 실패했습니다: ${e.toString()}')),
        );
      }
    }
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '정말 로그아웃하시겠습니까?',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
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
                        child: const Text('취소'),
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
                        ),
                        child: const Text('로그아웃'),
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
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

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
              backgroundColor: const Color(0xFF10B981),
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

  void _clearMasterDataCache(BuildContext context, WidgetRef ref) async {
    try {
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
}
