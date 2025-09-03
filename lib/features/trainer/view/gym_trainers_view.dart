import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodel/trainer_viewmodel.dart';
import '../model/trainer_model.dart';

class GymTrainersView extends ConsumerStatefulWidget {
  final int gymId;

  const GymTrainersView({
    super.key,
    required this.gymId,
  });

  @override
  ConsumerState<GymTrainersView> createState() => _GymTrainersViewState();
}

class _GymTrainersViewState extends ConsumerState<GymTrainersView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 헬스장 ID로 트레이너 목록 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(trainerProfileViewModelProvider.notifier)
          .loadTrainersByGymId(widget.gymId);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trainersState = ref.watch(trainerProfileViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50] ?? const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Choose Your Trainer',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search trainers...',
                hintStyle: TextStyle(color: Colors.grey[400] ?? Colors.grey),
                prefixIcon:
                    Icon(Icons.search, color: Colors.grey[400] ?? Colors.grey),
                filled: true,
                fillColor: Colors.grey[100] ?? const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onChanged: (value) {
                ref
                    .read(trainerProfileViewModelProvider.notifier)
                    .searchTrainers(value);
              },
            ),
          ),
          Expanded(
            child: trainersState.when(
              data: (trainers) {
                if (trainers.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_search,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No trainers found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or check back later',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: trainers.length,
                  itemBuilder: (context, index) {
                    final trainer = trainers[index];
                    return _buildTrainerCard(trainer);
                  },
                );
              },
              loading: () => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading trainers...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Error loading trainers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(trainerProfileViewModelProvider.notifier)
                            .loadTrainersByGymId(widget.gymId);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3498DB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Retry',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainerCard(TrainerProfile trainer) {
    return GestureDetector(
      onTap: () {
        context.push('/trainer-detail/${trainer.trainerId}', extra: trainer);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Avatar
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.grey[200] ?? const Color(0xFFEEEEEE),
                child: Icon(
                  Icons.person,
                  size: 35,
                  color: Colors.grey[600] ?? Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              // Trainer Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Rating Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            trainer.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Email or ID (show available info)
                    if (trainer.email != null && trainer.email!.isNotEmpty) ...[
                      Text(
                        trainer.email!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600] ?? Colors.grey,
                        ),
                      ),
                    ] else ...[
                      Text(
                        '트레이너 ID: ${trainer.trainerId}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600] ?? Colors.grey,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    // Introduction
                    if (trainer.introduction != null &&
                        trainer.introduction!.isNotEmpty) ...[
                      Text(
                        trainer.introduction!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700] ?? Colors.grey,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                    ],
                    // Specialties Tags
                    if (trainer.specialties.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: trainer.specialties.take(3).map((specialty) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[50] ??
                                  Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.blue[200] ??
                                    Colors.blue.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              specialty.toString(),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.blue[700] ?? Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Action Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Certifications count (optional)
                        if (trainer.certifications.isNotEmpty)
                          Text(
                            '${trainer.certifications.length} certifications',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600] ?? Colors.grey,
                            ),
                          )
                        else
                          const SizedBox(),
                      ],
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
}
