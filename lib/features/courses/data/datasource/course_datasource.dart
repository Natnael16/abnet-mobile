import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../main.dart';
import '../models/course.dart';

abstract class CoursesRemoteDataSource {
 Future<List<Course>> getCourses();
}

class CoursesRemoteDataSourceImpl implements CoursesRemoteDataSource {
  @override
  Future<List<Course>> getCourses() async {
    final response = await supabase
        .from('course')
        .select('id, created_at, title, description');

    if (response.isEmpty) {
      throw Exception('Error fetching courses');
    }

    List<Course> courses = (response as List<dynamic>)
        .map((course) => Course.fromJson(course))
        .toList();

    return courses;
  }
  // @override
  // Either<Future<List<Course>>, Failure> getCourses() async {
  //   
  // }
}
