import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/sync/model/sync_models.dart';
import '../../features/sync/viewmodel/sync_viewmodel.dart';

class ExerciseAutocompleteField extends ConsumerStatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final Function(Exercise)? onExerciseSelected;
  final Function(String)? onTextChanged;
  final String? initialValue;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const ExerciseAutocompleteField({
    super.key,
    this.labelText = '운동 선택',
    this.hintText = '운동 이름을 입력하세요',
    this.controller,
    this.onExerciseSelected,
    this.onTextChanged,
    this.initialValue,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  ConsumerState<ExerciseAutocompleteField> createState() => _ExerciseAutocompleteFieldState();
}

class _ExerciseAutocompleteFieldState extends ConsumerState<ExerciseAutocompleteField> {
  late TextEditingController _controller;
  List<Exercise> _filteredExercises = [];
  bool _showSuggestions = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }

    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _removeOverlay();
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    widget.onTextChanged?.call(text);

    if (text.isEmpty) {
      _filteredExercises.clear();
      _removeOverlay();
      return;
    }

    // 캐시된 운동 데이터에서 검색
    final cachedExercisesAsync = ref.read(cachedExercisesProvider);
    cachedExercisesAsync.whenData((exercises) {
      _filterExercises(exercises, text);
    });
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus && _controller.text.isNotEmpty) {
      _showSuggestionsOverlay();
    } else {
      // 포커스를 잃었을 때 약간의 지연 후 오버레이 제거
      Future.delayed(const Duration(milliseconds: 150), () {
        if (!_focusNode.hasFocus) {
          _removeOverlay();
        }
      });
    }
  }

  void _filterExercises(List<Exercise> exercises, String query) {
    if (query.isEmpty) {
      _filteredExercises.clear();
      _removeOverlay();
      return;
    }

    final filtered = exercises.where((exercise) {
      return exercise.name.toLowerCase().contains(query.toLowerCase());
    }).take(5).toList(); // 최대 5개까지만 표시

    setState(() {
      _filteredExercises = filtered;
    });

    if (filtered.isNotEmpty) {
      _showSuggestionsOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showSuggestionsOverlay() {
    _removeOverlay();
    
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60), // TextField 아래에 표시
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filteredExercises.length,
                itemBuilder: (context, index) {
                  final exercise = _filteredExercises[index];
                  return _buildSuggestionItem(exercise);
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildSuggestionItem(Exercise exercise) {
    return InkWell(
      onTap: () {
        _selectExercise(exercise);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (exercise.targetMuscles.isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: exercise.targetMuscles
                    .where((muscle) => muscle.role == MuscleRole.primary)
                    .take(3)
                    .map((muscle) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            muscle.name,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.blue[700],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _selectExercise(Exercise exercise) {
    _controller.text = exercise.name;
    widget.onExerciseSelected?.call(exercise);
    _removeOverlay();
    _focusNode.unfocus();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final cachedExercisesAsync = ref.watch(cachedExercisesProvider);

    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        children: [
          TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            cursorColor: Colors.black87, // 커서 색상을 검은색으로
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              prefixIcon: widget.prefixIcon ?? const Icon(Icons.fitness_center),
              suffixIcon: widget.suffixIcon ??
                  (_controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            _removeOverlay();
                          },
                        )
                      : null),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black87, width: 2),
              ),
            ),
          ),
          // 로딩 상태 표시
          cachedExercisesAsync.when(
            data: (exercises) {
              if (exercises.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.orange[600]),
                      const SizedBox(width: 4),
                      Text(
                        '운동 데이터를 동기화해주세요',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[600],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '운동 데이터를 불러오는 중...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(Icons.error_outline, size: 16, color: Colors.red[600]),
                  const SizedBox(width: 4),
                  Text(
                    '운동 데이터 로딩 실패',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 운동 선택 결과를 담는 클래스
class SelectedExercise {
  final Exercise exercise;
  final String displayName;

  SelectedExercise({
    required this.exercise,
    required this.displayName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedExercise &&
          runtimeType == other.runtimeType &&
          exercise.exerciseId == other.exercise.exerciseId;

  @override
  int get hashCode => exercise.exerciseId.hashCode;
}