import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/auth_provider.dart';
import '../model/pt_offering_model.dart';
import '../viewmodel/pt_offering_viewmodel.dart';

class PtOfferingCreateView extends ConsumerStatefulWidget {
  const PtOfferingCreateView({super.key});

  @override
  ConsumerState<PtOfferingCreateView> createState() => _PtOfferingCreateViewState();
}

class _PtOfferingCreateViewState extends ConsumerState<PtOfferingCreateView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _totalSessionsController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _totalSessionsController.dispose();
    super.dispose();
  }

  Future<void> _createPtOffering() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider);
    if (user?.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = CreatePtOfferingRequest(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: int.parse(_priceController.text.trim()),
        totalSessions: int.parse(_totalSessionsController.text.trim()),
        trainerId: int.parse(user!.id),
      );

      final success = await ref.read(ptOfferingProvider.notifier).createPtOffering(request);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PT 상품이 성공적으로 생성되었습니다.')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PT 상품 생성'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _createPtOffering,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('생성'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '기본 정보',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: '상품명',
                          hintText: '예: 초급자 대상 PT 10회 패키지',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '상품명을 입력해주세요.';
                          }
                          if (value.trim().length < 5) {
                            return '상품명은 5자 이상 입력해주세요.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: '상품 설명',
                          hintText: '헬스를 처음 시작하는 분들을 위한 맞춤형 트레이닝입니다.',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '상품 설명을 입력해주세요.';
                          }
                          if (value.trim().length < 10) {
                            return '상품 설명은 10자 이상 입력해주세요.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '가격 및 세션',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _priceController,
                              decoration: const InputDecoration(
                                labelText: '가격 (원)',
                                hintText: '500000',
                                border: OutlineInputBorder(),
                                prefixText: '₩ ',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return '가격을 입력해주세요.';
                                }
                                final price = int.tryParse(value.trim());
                                if (price == null || price <= 0) {
                                  return '올바른 가격을 입력해주세요.';
                                }
                                if (price < 10000) {
                                  return '가격은 10,000원 이상이어야 합니다.';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _totalSessionsController,
                              decoration: const InputDecoration(
                                labelText: '총 세션 수',
                                hintText: '10',
                                border: OutlineInputBorder(),
                                suffixText: '회',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return '세션 수를 입력해주세요.';
                                }
                                final sessions = int.tryParse(value.trim());
                                if (sessions == null || sessions <= 0) {
                                  return '올바른 세션 수를 입력해주세요.';
                                }
                                if (sessions > 100) {
                                  return '세션 수는 100회를 초과할 수 없습니다.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          '안내사항',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• PT 상품 생성 후 회원들이 바로 예약할 수 있습니다.\n'
                      '• 상품 정보는 언제든지 수정할 수 있습니다.\n'
                      '• 가격과 세션 수는 신중히 설정해주세요.',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 14,
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
}