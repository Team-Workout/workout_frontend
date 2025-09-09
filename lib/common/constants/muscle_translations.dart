/// 운동 부위 및 근육 한글 번역 맵
class MuscleTranslations {
  static const Map<String, String> muscleGroupTranslations = {
    // 상체
    'chest': '가슴',
    'shoulders': '어깨',
    'back': '등',
    'arms': '팔',
    'biceps': '이두',
    'triceps': '삼두',
    'forearms': '전완',
    
    // 하체
    'legs': '하체',
    'quadriceps': '대퇴사두',
    'hamstrings': '햄스트링',
    'glutes': '둔근',
    'calves': '종아리',
    
    // 코어
    'core': '복근',
    'abs': '복근',
    'obliques': '복사근',
    
    // 세부 근육
    'anterior deltoid': '전면삼각근',
    'middle deltoid': '중간삼각근',
    'posterior deltoid': '후면삼각근',
    'pectoralis major': '대흉근',
    'latissimus dorsi': '광배근',
    'rhomboids': '능형근',
    'trapezius': '승모근',
    'serratus anterior': '전거근',
    'rectus abdominis': '복직근',
    'transverse abdominis': '복횡근',
    'erector spinae': '척추기립근',
    'gluteus maximus': '대둔근',
    'gluteus medius': '중둔근',
    'vastus lateralis': '외측광근',
    'vastus medialis': '내측광근',
    'rectus femoris': '대퇴직근',
    'biceps femoris': '대퇴이두근',
    'gastrocnemius': '비복근',
    'soleus': '가자미근',
  };

  static const Map<String, List<String>> muscleGroupCategories = {
    '가슴': ['chest', 'pectoralis major'],
    '어깨': ['shoulders', 'anterior deltoid', 'middle deltoid', 'posterior deltoid'],
    '등': ['back', 'latissimus dorsi', 'rhomboids', 'trapezius'],
    '팔': ['arms', 'biceps', 'triceps', 'forearms'],
    '하체': ['legs', 'quadriceps', 'hamstrings', 'glutes', 'calves', 'vastus lateralis', 'vastus medialis', 'rectus femoris', 'biceps femoris', 'gluteus maximus', 'gluteus medius'],
    '복근': ['core', 'abs', 'obliques', 'rectus abdominis', 'transverse abdominis'],
    '전신': [], // 전체 운동용
  };

  /// 영어 근육명을 한글로 번역
  static String translateMuscle(String englishName) {
    return muscleGroupTranslations[englishName.toLowerCase()] ?? englishName;
  }

  /// 운동이 특정 부위에 속하는지 확인
  static bool exerciseBelongsToCategory(List<String> targetMuscles, String category) {
    if (category == '전신') return true;
    
    final categoryMuscles = muscleGroupCategories[category] ?? [];
    return targetMuscles.any((muscle) => 
      categoryMuscles.any((categoryMuscle) => 
        muscle.toLowerCase().contains(categoryMuscle.toLowerCase()) ||
        categoryMuscle.toLowerCase().contains(muscle.toLowerCase())
      )
    );
  }

  /// 부위 목록 가져오기
  static List<String> get categories => muscleGroupCategories.keys.toList();
}