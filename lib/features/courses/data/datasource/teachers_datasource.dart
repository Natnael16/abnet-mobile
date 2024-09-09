import '../../../../main.dart';
import '../models/teacher.dart';

Future<List<Teacher>> getCourseTeachers(int courseId, String? query) async {
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

  if (response.isEmpty) {
    return [];
  }
  List<Teacher> teachers = [];
  for (var teach in response) {
    if (query == null || teach['teacher']['name'].contains(query)) {
      teachers.add(Teacher.fromJson(teach['teacher']));
    }
  }
  return teachers;
}
