import 'dart:io';

import '../models/course.dart';
import '../models/teacher.dart';
import '../models/topic.dart';

Future<bool> createDocument(Course course, Teacher teacher, Topic topic,
    List<Topic> subTopics, String? doc, String media) async {
  print([course, teacher, topic, subTopics, doc, media]);
  return true;
}
