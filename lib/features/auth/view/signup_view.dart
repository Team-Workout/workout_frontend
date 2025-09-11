import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pt_service/features/auth/model/user_model.dart';
import 'package:pt_service/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:pt_service/features/body_composition/widget/custom_date_picker.dart';
import 'package:intl/intl.dart';

class SignupView extends ConsumerStatefulWidget {
  const SignupView({super.key});

  @override
  ConsumerState<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _birthdayController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreedToTerms = false;
  String? _selectedGender;
  String _selectedRole = '회원';

  // 실시간 유효성 검사 상태
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateName);
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  void _validateName() {
    setState(() {
      if (_nameController.text.isEmpty) {
        _nameError = null;
      } else if (_nameController.text.trim().length < 2) {
        _nameError = '이름은 최소 2자 이상이어야 합니다';
      } else {
        _nameError = null;
      }
    });
  }

  void _validateEmail() {
    setState(() {
      if (_emailController.text.isEmpty) {
        _emailError = null;
      } else if (!_emailController.text.contains('@') ||
          !_emailController.text.contains('.')) {
        _emailError = '올바른 이메일 형식이 아닙니다';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword() {
    setState(() {
      if (_passwordController.text.isEmpty) {
        _passwordError = null;
      } else if (_passwordController.text.length < 8) {
        _passwordError = '비밀번호는 최소 8자 이상이어야 합니다';
      } else {
        _passwordError = null;
      }
      // 비밀번호가 변경되면 확인 비밀번호도 다시 검증
      _validateConfirmPassword();
    });
  }

  void _validateConfirmPassword() {
    setState(() {
      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = null;
      } else if (_confirmPasswordController.text != _passwordController.text) {
        _confirmPasswordError = '비밀번호가 일치하지 않습니다';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showCustomDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text = DateFormat('yyyy년 MM월 dd일').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewState = ref.watch(authViewModelProvider);

    // 회원가입 성공 시 로그인 화면으로 이동
    ref.listen<AuthViewState>(authViewModelProvider, (previous, next) {
      if (next.signupSuccess) {
        // 성공 메시지 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    next.successMessage ?? '회원가입이 완료되었습니다! 로그인해주세요.',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 4),
          ),
        );
        // 로그인 화면으로 이동
        Future.delayed(const Duration(milliseconds: 500), () {
          context.pop();
        });
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF10B981),
              Color(0xFF34D399),
              Color(0xFF6EE7B7),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => context.pop(),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '회원가입',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Welcome Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF10B981),
                                      Color(0xFF059669)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF10B981)
                                          .withValues(alpha: 0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.person_add,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'WORKOUT 가입하기',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF10B981),
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '나만의 피트니스 여정을 시작하세요',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildRoleButton('회원'),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildRoleButton('트레이너'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Form Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Name Field
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981)
                                      .withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _nameError != null
                                        ? Colors.red.withValues(alpha: 0.5)
                                        : const Color(0xFF10B981)
                                            .withValues(alpha: 0.2),
                                    width: 1.5,
                                  ),
                                ),
                                child: TextFormField(
                                  cursorColor: Colors.black,
                                  controller: _nameController,
                                  style: const TextStyle(
                                    fontFamily: 'IBMPlexSansKR',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: '이름을 입력하세요',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'IBMPlexSansKR',
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(20),
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: Color(0xFF10B981),
                                      size: 22,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '이름을 입력해주세요';
                                    }
                                    if (value.trim().length < 2) {
                                      return '이름은 최소 2자 이상이어야 합니다';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              if (_nameError != null) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: Colors.red.shade200),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red.shade600,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _nameError!,
                                          style: TextStyle(
                                            color: Colors.red.shade700,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'IBMPlexSansKR',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 20),
                              // Email Field
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981)
                                      .withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _emailError != null
                                        ? Colors.red.withValues(alpha: 0.5)
                                        : const Color(0xFF10B981)
                                            .withValues(alpha: 0.2),
                                    width: 1.5,
                                  ),
                                ),
                                child: TextFormField(
                                  cursorColor: Colors.black,
                                  controller: _emailController,
                                  style: const TextStyle(
                                    fontFamily: 'IBMPlexSansKR',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'you@example.com',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'IBMPlexSansKR',
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(20),
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: Color(0xFF10B981),
                                      size: 22,
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '이메일을 입력해주세요';
                                    }
                                    if (!value.contains('@') ||
                                        !value.contains('.')) {
                                      return '올바른 이메일 형식이 아닙니다';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              if (_emailError != null) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: Colors.red.shade200),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red.shade600,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _emailError!,
                                          style: TextStyle(
                                            color: Colors.red.shade700,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'IBMPlexSansKR',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 20),
                              // Password Field
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981)
                                      .withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _passwordError != null
                                        ? Colors.red.withValues(alpha: 0.5)
                                        : const Color(0xFF10B981)
                                            .withValues(alpha: 0.2),
                                    width: 1.5,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  style: const TextStyle(
                                    fontFamily: 'IBMPlexSansKR',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: '비밀번호를 입력하세요',
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'IBMPlexSansKR',
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(20),
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: Color(0xFF10B981),
                                      size: 22,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: const Color(0xFF10B981),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '비밀번호를 입력해주세요';
                                    }
                                    if (value.length < 8) {
                                      return '비밀번호는 최소 8자 이상이어야 합니다';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              if (_passwordError != null) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: Colors.red.shade200),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red.shade600,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _passwordError!,
                                          style: TextStyle(
                                            color: Colors.red.shade700,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'IBMPlexSansKR',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 20),
                              // Confirm Password Field
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981)
                                      .withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _confirmPasswordError != null
                                        ? Colors.red.withValues(alpha: 0.5)
                                        : const Color(0xFF10B981)
                                            .withValues(alpha: 0.2),
                                    width: 1.5,
                                  ),
                                ),
                                child: TextFormField(
                                  cursorColor: Colors.black,
                                  controller: _confirmPasswordController,
                                  obscureText: !_isConfirmPasswordVisible,
                                  style: const TextStyle(
                                    fontFamily: 'IBMPlexSansKR',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: '비밀번호를 다시 입력하세요',
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'IBMPlexSansKR',
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(20),
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: Color(0xFF10B981),
                                      size: 22,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isConfirmPasswordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: const Color(0xFF10B981),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isConfirmPasswordVisible =
                                              !_isConfirmPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '비밀번호 확인을 입력해주세요';
                                    }
                                    if (value != _passwordController.text) {
                                      return '비밀번호가 일치하지 않습니다';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              if (_confirmPasswordError != null) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: Colors.red.shade200),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red.shade600,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _confirmPasswordError!,
                                          style: TextStyle(
                                            color: Colors.red.shade700,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'IBMPlexSansKR',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 20),
                              // Birthday Field
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981)
                                      .withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFF10B981)
                                        .withValues(alpha: 0.2),
                                    width: 1.5,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _birthdayController,
                                  readOnly: true,
                                  style: const TextStyle(
                                    fontFamily: 'IBMPlexSansKR',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: '생년월일을 선택하세요',
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'IBMPlexSansKR',
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(20),
                                    prefixIcon: const Icon(
                                      Icons.cake_outlined,
                                      color: Color(0xFF10B981),
                                      size: 22,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.calendar_today,
                                          color: Color(0xFF10B981)),
                                      onPressed: () => _selectDate(context),
                                    ),
                                  ),
                                  onTap: () => _selectDate(context),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Gender Selection
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildGenderButton('남성'),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildGenderButton('여성'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Terms Agreement
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _agreedToTerms = !_agreedToTerms;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981)
                                        .withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFF10B981)
                                          .withValues(alpha: 0.1),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: _agreedToTerms
                                              ? const Color(0xFF10B981)
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                            color: const Color(0xFF10B981),
                                            width: 2,
                                          ),
                                        ),
                                        child: _agreedToTerms
                                            ? const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 14,
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14,
                                              fontFamily: 'IBMPlexSansKR',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            children: const [
                                              TextSpan(text: '다음에 동의합니다: '),
                                              TextSpan(
                                                text: '서비스 이용약관',
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Color(0xFF10B981),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              TextSpan(text: ' 및 '),
                                              TextSpan(
                                                text: '개인정보 처리방침',
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Color(0xFF10B981),
                                                  fontWeight: FontWeight.w600,
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
                              const SizedBox(height: 32),
                              // Signup Button
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: (!_agreedToTerms ||
                                            authViewState.isLoading)
                                        ? [Colors.grey[400]!, Colors.grey[500]!]
                                        : [
                                            const Color(0xFF10B981),
                                            const Color(0xFF059669)
                                          ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    if (_agreedToTerms &&
                                        !authViewState.isLoading)
                                      BoxShadow(
                                        color: const Color(0xFF10B981)
                                            .withValues(alpha: 0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: (!_agreedToTerms ||
                                            authViewState.isLoading)
                                        ? null
                                        : () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              if (_selectedGender == null) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: const Text(
                                                      '성별을 선택해주세요',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'IBMPlexSansKR'),
                                                    ),
                                                    backgroundColor: Colors.red,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                );
                                                return;
                                              }
                                              // 성별을 영어로 변환
                                              String? genderInEnglish;
                                              if (_selectedGender == '남성') {
                                                genderInEnglish = 'Male';
                                              } else if (_selectedGender ==
                                                  '여성') {
                                                genderInEnglish = 'Female';
                                              }

                                              ref
                                                  .read(authViewModelProvider
                                                      .notifier)
                                                  .signup(
                                                    email:
                                                        _emailController.text,
                                                    password:
                                                        _passwordController
                                                            .text,
                                                    name: _nameController.text,
                                                    userType:
                                                        _selectedRole == '회원'
                                                            ? UserType.member
                                                            : UserType.trainer,
                                                    gender: genderInEnglish,
                                                  );
                                            }
                                          },
                                    child: Center(
                                      child: authViewState.isLoading
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.person_add,
                                                    color: Colors.white,
                                                    size: 24),
                                                SizedBox(width: 12),
                                                Text(
                                                  '가입하기',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'IBMPlexSansKR',
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Login Link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '이미 계정이 있으신가요? ',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'IBMPlexSansKR',
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      context.pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF10B981)
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        '로그인',
                                        style: TextStyle(
                                          color: Color(0xFF10B981),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'IBMPlexSansKR',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (authViewState.error != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red.shade600,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    authViewState.error!,
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'IBMPlexSansKR',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderButton(String gender) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                )
              : null,
          color: isSelected
              ? null
              : const Color(0xFF10B981).withValues(alpha: 0.05),
          border: Border.all(
            color: const Color(0xFF10B981)
                .withValues(alpha: isSelected ? 0.8 : 0.2),
            width: isSelected ? 2 : 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF10B981).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                gender == '남성' ? Icons.male : Icons.female,
                color: isSelected ? Colors.white : const Color(0xFF10B981),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                gender,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF10B981),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(String role) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                )
              : null,
          color: isSelected
              ? null
              : const Color(0xFF10B981).withValues(alpha: 0.05),
          border: Border.all(
            color: const Color(0xFF10B981)
                .withValues(alpha: isSelected ? 0.8 : 0.2),
            width: isSelected ? 2 : 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF10B981).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                role == '회원' ? Icons.person : Icons.fitness_center,
                color: isSelected ? Colors.white : const Color(0xFF10B981),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                role,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF10B981),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
