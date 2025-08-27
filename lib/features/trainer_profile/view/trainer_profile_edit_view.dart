import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/auth_provider.dart';
import '../model/trainer_profile_model.dart';
import '../viewmodel/trainer_profile_viewmodel.dart';

class TrainerProfileEditView extends ConsumerStatefulWidget {
  const TrainerProfileEditView({super.key});

  @override
  ConsumerState<TrainerProfileEditView> createState() =>
      _TrainerProfileEditViewState();
}

class _TrainerProfileEditViewState
    extends ConsumerState<TrainerProfileEditView> {
  final _formKey = GlobalKey<FormState>();
  final _introductionController = TextEditingController();
  final _specialtyController = TextEditingController();

  final List<TextEditingController> _awardNameControllers = [];
  final List<TextEditingController> _awardDateControllers = [];
  final List<TextEditingController> _awardPlaceControllers = [];

  final List<TextEditingController> _certNameControllers = [];
  final List<TextEditingController> _certOrgControllers = [];
  final List<TextEditingController> _certDateControllers = [];

  final List<TextEditingController> _eduSchoolControllers = [];
  final List<TextEditingController> _eduNameControllers = [];
  final List<TextEditingController> _eduDegreeControllers = [];
  final List<TextEditingController> _eduStartControllers = [];
  final List<TextEditingController> _eduEndControllers = [];

  final List<TextEditingController> _workNameControllers = [];
  final List<TextEditingController> _workPlaceControllers = [];
  final List<TextEditingController> _workPositionControllers = [];
  final List<TextEditingController> _workStartControllers = [];
  final List<TextEditingController> _workEndControllers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _introductionController.dispose();
    _specialtyController.dispose();
    _disposeAllControllers();
    super.dispose();
  }

  void _disposeAllControllers() {
    for (var controller in _awardNameControllers) controller.dispose();
    for (var controller in _awardDateControllers) controller.dispose();
    for (var controller in _awardPlaceControllers) controller.dispose();
    for (var controller in _certNameControllers) controller.dispose();
    for (var controller in _certOrgControllers) controller.dispose();
    for (var controller in _certDateControllers) controller.dispose();
    for (var controller in _eduSchoolControllers) controller.dispose();
    for (var controller in _eduNameControllers) controller.dispose();
    for (var controller in _eduDegreeControllers) controller.dispose();
    for (var controller in _eduStartControllers) controller.dispose();
    for (var controller in _eduEndControllers) controller.dispose();
    for (var controller in _workNameControllers) controller.dispose();
    for (var controller in _workPlaceControllers) controller.dispose();
    for (var controller in _workPositionControllers) controller.dispose();
    for (var controller in _workStartControllers) controller.dispose();
    for (var controller in _workEndControllers) controller.dispose();
  }

  void _initializeControllers(TrainerProfile profile) {
    _introductionController.text = profile.introduction;

    _initializeListControllers(profile);
  }

  void _initializeListControllers(TrainerProfile profile) {
    // Clear existing controllers
    _disposeAllControllers();
    _awardNameControllers.clear();
    _awardDateControllers.clear();
    _awardPlaceControllers.clear();

    // Awards
    for (var award in profile.awards) {
      _awardNameControllers.add(TextEditingController(text: award.awardName));
      _awardDateControllers.add(TextEditingController(text: award.awardDate));
      _awardPlaceControllers.add(TextEditingController(text: award.awardPlace));
    }

    // Certifications
    _certNameControllers.clear();
    _certOrgControllers.clear();
    _certDateControllers.clear();
    for (var cert in profile.certifications) {
      _certNameControllers
          .add(TextEditingController(text: cert.certificationName));
      _certOrgControllers
          .add(TextEditingController(text: cert.issuingOrganization));
      _certDateControllers
          .add(TextEditingController(text: cert.acquisitionDate));
    }

    // Education
    _eduSchoolControllers.clear();
    _eduNameControllers.clear();
    _eduDegreeControllers.clear();
    _eduStartControllers.clear();
    _eduEndControllers.clear();
    for (var edu in profile.educations) {
      _eduSchoolControllers.add(TextEditingController(text: edu.schoolName));
      _eduNameControllers.add(TextEditingController(text: edu.educationName));
      _eduDegreeControllers.add(TextEditingController(text: edu.degree));
      _eduStartControllers.add(TextEditingController(text: edu.startDate));
      _eduEndControllers.add(TextEditingController(text: edu.endDate ?? ''));
    }

    // Work Experience
    _workNameControllers.clear();
    _workPlaceControllers.clear();
    _workPositionControllers.clear();
    _workStartControllers.clear();
    _workEndControllers.clear();
    for (var work in profile.workExperiences) {
      _workNameControllers.add(TextEditingController(text: work.workName));
      _workPlaceControllers.add(TextEditingController(text: work.workPlace));
      _workPositionControllers
          .add(TextEditingController(text: work.workPosition));
      _workStartControllers
          .add(TextEditingController(text: work.workStartDate));
      _workEndControllers
          .add(TextEditingController(text: work.workEndDate ?? ''));
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text = picked.toIso8601String().split('T')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(trainerProfileViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '프로필 수정',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _saveProfile(),
            child: const Text(
              '저장',
              style: TextStyle(
                color: Color(0xFF2C3E50),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: profileState.when(
        data: (profile) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_introductionController.text.isEmpty) {
              _initializeControllers(profile);
            }
          });

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 프로필 헤더 추가
                  if (profile.name != null || profile.email != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color(0xFF2C3E50),
                            child: Text(
                              profile.name?.substring(0, 1).toUpperCase() ??
                                  'T',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile.name ?? '트레이너',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  profile.email ?? '',
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
                    ),
                  if (profile.name != null || profile.email != null)
                    const SizedBox(height: 24),
                  _buildIntroductionSection(),
                  const SizedBox(height: 24),
                  _buildSpecialtiesSection(profile),
                  const SizedBox(height: 24),
                  _buildAwardsSection(profile),
                  const SizedBox(height: 24),
                  _buildCertificationsSection(profile),
                  const SizedBox(height: 24),
                  _buildEducationsSection(profile),
                  const SizedBox(height: 24),
                  _buildWorkExperiencesSection(profile),
                  const SizedBox(height: 32),
                  _buildDangerZone(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('오류가 발생했습니다: $error'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref
                    .read(trainerProfileViewModelProvider.notifier)
                    .loadProfile(),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2C3E50),
                ),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroductionSection() {
    return _buildSection(
      title: '소개',
      child: TextFormField(
        controller: _introductionController,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: '자신을 소개해주세요...',
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '소개를 입력해주세요';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSpecialtiesSection(TrainerProfile profile) {
    return _buildSection(
      title: '전문 분야',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _specialtyController,
                  decoration: const InputDecoration(
                    hintText: '전문 분야를 입력하세요',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () {
                  if (_specialtyController.text.isNotEmpty) {
                    ref
                        .read(trainerProfileViewModelProvider.notifier)
                        .addSpecialty(_specialtyController.text);
                    _specialtyController.clear();
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2C3E50),
                ),
                child: const Text('추가'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: profile.specialties.map((specialty) {
              return Chip(
                label: Text(specialty),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  ref
                      .read(trainerProfileViewModelProvider.notifier)
                      .removeSpecialty(specialty);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAwardsSection(TrainerProfile profile) {
    return _buildSection(
      title: '수상 경력',
      child: Column(
        children: [
          ...List.generate(profile.awards.length, (index) {
            return _buildAwardCard(index);
          }),
          const SizedBox(height: 12),
          _buildAddButton('수상 경력 추가', () {
            ref.read(trainerProfileViewModelProvider.notifier).addAward();
            _awardNameControllers.add(TextEditingController());
            _awardDateControllers.add(TextEditingController());
            _awardPlaceControllers.add(TextEditingController());
          }),
        ],
      ),
    );
  }

  Widget _buildAwardCard(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '수상 경력 ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    ref
                        .read(trainerProfileViewModelProvider.notifier)
                        .removeAward(index);
                    if (index < _awardNameControllers.length) {
                      _awardNameControllers[index].dispose();
                      _awardDateControllers[index].dispose();
                      _awardPlaceControllers[index].dispose();
                      _awardNameControllers.removeAt(index);
                      _awardDateControllers.removeAt(index);
                      _awardPlaceControllers.removeAt(index);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (index < _awardNameControllers.length) ...[
              TextFormField(
                controller: _awardNameControllers[index],
                decoration: const InputDecoration(
                  labelText: '대회/상 이름',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _awardDateControllers[index],
                      decoration: InputDecoration(
                        labelText: '수상일',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(
                              context, _awardDateControllers[index]),
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _awardPlaceControllers[index],
                      decoration: const InputDecoration(
                        labelText: '순위/등급',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCertificationsSection(TrainerProfile profile) {
    return _buildSection(
      title: '자격증',
      child: Column(
        children: [
          ...List.generate(profile.certifications.length, (index) {
            return _buildCertificationCard(index);
          }),
          const SizedBox(height: 12),
          _buildAddButton('자격증 추가', () {
            ref
                .read(trainerProfileViewModelProvider.notifier)
                .addCertification();
            _certNameControllers.add(TextEditingController());
            _certOrgControllers.add(TextEditingController());
            _certDateControllers.add(TextEditingController());
          }),
        ],
      ),
    );
  }

  Widget _buildCertificationCard(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '자격증 ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    ref
                        .read(trainerProfileViewModelProvider.notifier)
                        .removeCertification(index);
                    if (index < _certNameControllers.length) {
                      _certNameControllers[index].dispose();
                      _certOrgControllers[index].dispose();
                      _certDateControllers[index].dispose();
                      _certNameControllers.removeAt(index);
                      _certOrgControllers.removeAt(index);
                      _certDateControllers.removeAt(index);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (index < _certNameControllers.length) ...[
              TextFormField(
                controller: _certNameControllers[index],
                decoration: const InputDecoration(
                  labelText: '자격증명',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _certOrgControllers[index],
                decoration: const InputDecoration(
                  labelText: '발급기관',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _certDateControllers[index],
                decoration: InputDecoration(
                  labelText: '취득일',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () =>
                        _selectDate(context, _certDateControllers[index]),
                  ),
                ),
                readOnly: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEducationsSection(TrainerProfile profile) {
    return _buildSection(
      title: '학력',
      child: Column(
        children: [
          ...List.generate(profile.educations.length, (index) {
            return _buildEducationCard(index);
          }),
          const SizedBox(height: 12),
          _buildAddButton('학력 추가', () {
            ref.read(trainerProfileViewModelProvider.notifier).addEducation();
            _eduSchoolControllers.add(TextEditingController());
            _eduNameControllers.add(TextEditingController());
            _eduDegreeControllers.add(TextEditingController());
            _eduStartControllers.add(TextEditingController());
            _eduEndControllers.add(TextEditingController());
          }),
        ],
      ),
    );
  }

  Widget _buildEducationCard(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '학력 ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    ref
                        .read(trainerProfileViewModelProvider.notifier)
                        .removeEducation(index);
                    if (index < _eduSchoolControllers.length) {
                      _eduSchoolControllers[index].dispose();
                      _eduNameControllers[index].dispose();
                      _eduDegreeControllers[index].dispose();
                      _eduStartControllers[index].dispose();
                      _eduEndControllers[index].dispose();
                      _eduSchoolControllers.removeAt(index);
                      _eduNameControllers.removeAt(index);
                      _eduDegreeControllers.removeAt(index);
                      _eduStartControllers.removeAt(index);
                      _eduEndControllers.removeAt(index);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (index < _eduSchoolControllers.length) ...[
              TextFormField(
                controller: _eduSchoolControllers[index],
                decoration: const InputDecoration(
                  labelText: '학교명',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _eduNameControllers[index],
                      decoration: const InputDecoration(
                        labelText: '전공/학과',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _eduDegreeControllers[index],
                      decoration: const InputDecoration(
                        labelText: '학위',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _eduStartControllers[index],
                      decoration: InputDecoration(
                        labelText: '입학일',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () =>
                              _selectDate(context, _eduStartControllers[index]),
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _eduEndControllers[index],
                      decoration: InputDecoration(
                        labelText: '졸업일 (선택)',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () =>
                              _selectDate(context, _eduEndControllers[index]),
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWorkExperiencesSection(TrainerProfile profile) {
    return _buildSection(
      title: '경력',
      child: Column(
        children: [
          ...List.generate(profile.workExperiences.length, (index) {
            return _buildWorkExperienceCard(index);
          }),
          const SizedBox(height: 12),
          _buildAddButton('경력 추가', () {
            ref
                .read(trainerProfileViewModelProvider.notifier)
                .addWorkExperience();
            _workNameControllers.add(TextEditingController());
            _workPlaceControllers.add(TextEditingController());
            _workPositionControllers.add(TextEditingController());
            _workStartControllers.add(TextEditingController());
            _workEndControllers.add(TextEditingController());
          }),
        ],
      ),
    );
  }

  Widget _buildWorkExperienceCard(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '경력 ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    ref
                        .read(trainerProfileViewModelProvider.notifier)
                        .removeWorkExperience(index);
                    if (index < _workNameControllers.length) {
                      _workNameControllers[index].dispose();
                      _workPlaceControllers[index].dispose();
                      _workPositionControllers[index].dispose();
                      _workStartControllers[index].dispose();
                      _workEndControllers[index].dispose();
                      _workNameControllers.removeAt(index);
                      _workPlaceControllers.removeAt(index);
                      _workPositionControllers.removeAt(index);
                      _workStartControllers.removeAt(index);
                      _workEndControllers.removeAt(index);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (index < _workNameControllers.length) ...[
              TextFormField(
                controller: _workNameControllers[index],
                decoration: const InputDecoration(
                  labelText: '회사/헬스장명',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _workPlaceControllers[index],
                      decoration: const InputDecoration(
                        labelText: '근무지',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _workPositionControllers[index],
                      decoration: const InputDecoration(
                        labelText: '직책',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _workStartControllers[index],
                      decoration: InputDecoration(
                        labelText: '시작일',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(
                              context, _workStartControllers[index]),
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _workEndControllers[index],
                      decoration: InputDecoration(
                        labelText: '종료일 (현재 근무 시 공백)',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () =>
                              _selectDate(context, _workEndControllers[index]),
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildAddButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add),
        label: Text(text),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: const BorderSide(color: Color(0xFF2C3E50)),
          foregroundColor: const Color(0xFF2C3E50),
        ),
      ),
    );
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final profile = ref.read(trainerProfileViewModelProvider).value;
    if (profile == null) return;

    // Build awards - 기존 데이터 유지하며 수정
    final awards = <Award>[];
    for (int i = 0; i < _awardNameControllers.length && i < profile.awards.length; i++) {
      // 기존 항목 업데이트 (ID 유지)
      if (_awardNameControllers[i].text.isNotEmpty) {
        awards.add(profile.awards[i].copyWith(
          awardName: _awardNameControllers[i].text,
          awardDate: _awardDateControllers[i].text,
          awardPlace: _awardPlaceControllers[i].text,
        ));
      }
    }
    // 새로 추가된 항목들 (ID는 null)
    for (int i = profile.awards.length; i < _awardNameControllers.length; i++) {
      if (_awardNameControllers[i].text.isNotEmpty) {
        awards.add(Award(
          id: null,
          awardName: _awardNameControllers[i].text,
          awardDate: _awardDateControllers[i].text,
          awardPlace: _awardPlaceControllers[i].text,
        ));
      }
    }

    // Build certifications - 기존 데이터 유지하며 수정
    final certifications = <Certification>[];
    for (int i = 0; i < _certNameControllers.length && i < profile.certifications.length; i++) {
      // 기존 항목 업데이트 (ID 유지)
      if (_certNameControllers[i].text.isNotEmpty) {
        certifications.add(profile.certifications[i].copyWith(
          certificationName: _certNameControllers[i].text,
          issuingOrganization: _certOrgControllers[i].text,
          acquisitionDate: _certDateControllers[i].text,
        ));
      }
    }
    // 새로 추가된 항목들 (ID는 null)
    for (int i = profile.certifications.length; i < _certNameControllers.length; i++) {
      if (_certNameControllers[i].text.isNotEmpty) {
        certifications.add(Certification(
          id: null,
          certificationName: _certNameControllers[i].text,
          issuingOrganization: _certOrgControllers[i].text,
          acquisitionDate: _certDateControllers[i].text,
        ));
      }
    }

    // Build educations - 기존 데이터 유지하며 수정
    final educations = <Education>[];
    for (int i = 0; i < _eduSchoolControllers.length && i < profile.educations.length; i++) {
      // 기존 항목 업데이트 (ID 유지)
      if (_eduSchoolControllers[i].text.isNotEmpty) {
        educations.add(profile.educations[i].copyWith(
          schoolName: _eduSchoolControllers[i].text,
          educationName: _eduNameControllers[i].text,
          degree: _eduDegreeControllers[i].text,
          startDate: _eduStartControllers[i].text,
          endDate: _eduEndControllers[i].text.isEmpty ? null : _eduEndControllers[i].text,
        ));
      }
    }
    // 새로 추가된 항목들 (ID는 null)
    for (int i = profile.educations.length; i < _eduSchoolControllers.length; i++) {
      if (_eduSchoolControllers[i].text.isNotEmpty) {
        educations.add(Education(
          id: null,
          schoolName: _eduSchoolControllers[i].text,
          educationName: _eduNameControllers[i].text,
          degree: _eduDegreeControllers[i].text,
          startDate: _eduStartControllers[i].text,
          endDate: _eduEndControllers[i].text.isEmpty ? null : _eduEndControllers[i].text,
        ));
      }
    }

    // Build work experiences - 기존 데이터 유지하며 수정
    final workExperiences = <WorkExperience>[];
    for (int i = 0; i < _workNameControllers.length && i < profile.workExperiences.length; i++) {
      // 기존 항목 업데이트 (ID 유지)
      if (_workNameControllers[i].text.isNotEmpty) {
        workExperiences.add(profile.workExperiences[i].copyWith(
          workName: _workNameControllers[i].text,
          workPlace: _workPlaceControllers[i].text,
          workPosition: _workPositionControllers[i].text,
          workStartDate: _workStartControllers[i].text,
          workEndDate: _workEndControllers[i].text.isEmpty ? null : _workEndControllers[i].text,
        ));
      }
    }
    // 새로 추가된 항목들 (ID는 null)
    for (int i = profile.workExperiences.length; i < _workNameControllers.length; i++) {
      if (_workNameControllers[i].text.isNotEmpty) {
        workExperiences.add(WorkExperience(
          id: null,
          workName: _workNameControllers[i].text,
          workPlace: _workPlaceControllers[i].text,
          workPosition: _workPositionControllers[i].text,
          workStartDate: _workStartControllers[i].text,
          workEndDate: _workEndControllers[i].text.isEmpty ? null : _workEndControllers[i].text,
        ));
      }
    }

    // DELETE → PUT 방식으로 중복 에러 해결
    // 모든 데이터를 새로 생성하므로 ID는 null로 설정
    final updatedProfile = TrainerProfile(
      trainerId: profile.trainerId,
      name: profile.name,
      email: profile.email,
      introduction: _introductionController.text,
      awards: awards.map((award) => award.copyWith(id: null)).toList(), // 새 생성이므로 ID null
      certifications: certifications.map((cert) => cert.copyWith(id: null)).toList(),
      educations: educations.map((edu) => edu.copyWith(id: null)).toList(),
      workExperiences: workExperiences.map((work) => work.copyWith(id: null)).toList(),
      specialties: profile.specialties, // specialties는 현재 상태 그대로
    );

    ref
        .read(trainerProfileViewModelProvider.notifier)
        .updateProfile(updatedProfile);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('프로필이 저장되었습니다'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildDangerZone() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red.shade600,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '위험 구역',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '계정을 삭제하면 프로필, 운동 기록, 회원 정보 등 모든 데이터가 영구적으로 삭제됩니다.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.red.shade600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showDeleteAccountDialog(),
              icon: const Icon(Icons.delete_forever),
              label: const Text('계정 삭제'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade600,
                side: BorderSide(color: Colors.red.shade400),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red.shade600,
              size: 28,
            ),
            const SizedBox(width: 8),
            const Text('계정 삭제'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '정말로 계정을 삭제하시겠습니까?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),
            Text('삭제되는 데이터:'),
            SizedBox(height: 8),
            Text('• 프로필 정보 (소개, 경력, 자격증 등)'),
            Text('• 운동 기록 및 회원 관리 데이터'),
            Text('• 일정 및 메시지'),
            SizedBox(height: 12),
            Text(
              '이 작업은 되돌릴 수 없습니다.',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
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
              _deleteAccount();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() async {
    try {
      // 로딩 표시
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // 계정 삭제 API 호출
      await ref.read(trainerProfileViewModelProvider.notifier).deleteProfile();
      
      // 로딩 다이얼로그 닫기
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // 로그아웃 처리
      ref.read(authStateProvider.notifier).logout();

      // 로그인 페이지로 이동
      if (context.mounted) {
        context.go('/login');
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('계정이 성공적으로 삭제되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // 로딩 다이얼로그 닫기
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('계정 삭제 실패: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
