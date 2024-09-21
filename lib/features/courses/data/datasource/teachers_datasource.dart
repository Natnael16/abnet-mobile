import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import '../../../../main.dart';
import '../models/teacher.dart';

Future<List<Teacher>> getCourseTeachers(int courseId) async {
  final cacheBox = Hive.box('cacheBox');
  List<Teacher> teachers = [];

  // Cache key for teachers
  var cacheKey = 'teachers_$courseId';

  // Check for cached data first
  var cachedTeachers = cacheBox.get(cacheKey);
  if (cachedTeachers != null && (cachedTeachers as List<dynamic>).isNotEmpty) {
    teachers =
        (cachedTeachers).map((teach) => Teacher.fromJson(teach)).toList();

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      _updateTeachersCacheInBackground(courseId, cacheKey);
    }

    return teachers;
  }

  // If no cached data, check connectivity and fetch from the database
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult != ConnectivityResult.none) {
    final response = await supabase.from('teacher_course').select('''
          id,
          teacher_id,
          course_id,
          teacher (
            id,
            created_at,
            life_story,
            schools_attended,
            name
          )
        ''').eq('course_id', courseId);

    if (response.isNotEmpty) {
      List<Map<String, dynamic>> cacheTeachers = response
          .map((teach) => teach['teacher'] as Map<String, dynamic>)
          .toList();
      teachers = cacheTeachers.map((teach) => Teacher.fromJson(teach)).toList();
      cacheBox.put(cacheKey, cacheTeachers);
    }
  }

  return teachers;
}

void _updateTeachersCacheInBackground(int courseId, String cacheKey) async {
  final cacheBox = Hive.box('cacheBox');

  // Fetch fresh data from Supabase in the background
  final response = await supabase.from('teacher_course').select('''
        id,
        teacher_id,
        course_id,
        teacher (
          id,
          created_at,
          life_story,
          schools_attended,
          name
        )
      ''').eq('course_id', courseId);

  if (response.isNotEmpty) {
    List<Map<String, dynamic>> teachers = response
        .map((teach) => teach['teacher'] as Map<String, dynamic>)
        .toList();
    cacheBox.put(cacheKey, teachers);
  }
}
