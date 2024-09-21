import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import '../../../../main.dart';
import '../models/course.dart';

Future<List<Course>> getCourses() async {
  final cacheBox = Hive.box('cacheBox');
  List<Course> courses = [];

  // Cache key for courses
  var cacheKey = 'courses';

  // Check for cached data first
  var cachedCourses = cacheBox.get(cacheKey);
  if (cachedCourses != null && (cachedCourses as List<dynamic>).isNotEmpty) {
    courses = (cachedCourses).map((course) => Course.fromJson(course)).toList();

    // Check network connectivity and update cache in the background if needed
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      _updateCoursesCacheInBackground(cacheKey);
    }

    return courses;
  }

  // If no cached data, check connectivity and fetch from the database
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult != ConnectivityResult.none) {
    final response = await supabase
        .from('course')
        .select('id, created_at, title, description');
    if (response.isNotEmpty) {
      courses = (response as List<dynamic>)
          .map((course) => Course.fromJson(course))
          .toList();

      // Cache the fetched data
      cacheBox.put(cacheKey, response);
    }
  }

  return courses;
}

void _updateCoursesCacheInBackground(String cacheKey) async {
  final cacheBox = Hive.box('cacheBox');

  // Fetch fresh data from Supabase in the background
  var response = await supabase
      .from('course')
      .select('id, created_at, title, description');
  if (response.isNotEmpty) {
    cacheBox.put(cacheKey, response);
  }
}
