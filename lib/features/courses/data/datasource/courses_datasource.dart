import '../../../../main.dart';
import '../models/course.dart';

Future<List<Course>> getCourses() async {
  final response = await supabase
      .from('course')
      .select('id, created_at, title, description');

  if (response.isEmpty) {
    return [];
  }

  List<Course> courses = (response as List<dynamic>)
      .map((course) => Course.fromJson(course))
      .toList();

  return courses;
}
