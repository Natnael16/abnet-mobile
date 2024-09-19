import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import '../../../../main.dart';
import '../models/topic.dart';
import '../models/media.dart';

Future<List<Topic>> getTopics(int courseId, int teacherId, int? topicId) async {
  final cacheBox = Hive.box('cacheBox');
  List<Topic> topics = [];

  // Cache key for topics
  var cacheKey = 'topics_${courseId}_$teacherId';
  if (topicId != null) {
    cacheKey += '_$topicId';
  }

  // Check for cached data first
  var cachedTopics = cacheBox.get(cacheKey);

  if (cachedTopics.isNotEmpty) {
    
    List<dynamic> decodedTopics = jsonDecode(cachedTopics);
    topics = decodedTopics.map((topicMap) => Topic.fromJson(topicMap)).toList();

    // Check network connectivity and update cache in the background if needed
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      _updateTopicsCacheInBackground(courseId, teacherId, topicId, cacheKey);
    }

    return topics;
  }
  // If no cached data, check connectivity and fetch from the database
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult != ConnectivityResult.none) {
    List<dynamic> response;
    if (topicId == null) {
      List<dynamic> teacherCourse = await supabase
          .from("teacher_course")
          .select("id")
          .eq("course_id", courseId)
          .eq("teacher_id", teacherId)
          .limit(1);
      response = await supabase
          .from('topic')
          .select('*')
          .eq('teacher_course_id', teacherCourse.first['id']);
    } else {
      response = await supabase
          .from('topic')
          .select('*')
          .eq('super_topic_id', topicId);
    }
    print('response: ');
    topics = [];
    for (var t in response) {
      var topic = Topic.fromJson(t);
      Media? media = await doesTopicHasMedia(topic.id);
      topic.isTopicFinal = media != null;
      topic.media = media;
      topics.add(topic);
    }

    // Cache the fetched data
    print('enoding');
    cacheBox.put(
        cacheKey, jsonEncode(topics.map((topic) => topic.toJson()).toList()));
    print('ended');
  }

  return topics;
}

void _updateTopicsCacheInBackground(
    int courseId, int teacherId, int? topicId, String cacheKey) async {
  final cacheBox = Hive.box('cacheBox');

  List<dynamic> response;
  if (topicId == null) {
    List<dynamic> teacherCourse = await supabase
        .from("teacher_course")
        .select("id")
        .eq("course_id", courseId)
        .eq("teacher_id", teacherId)
        .limit(1);
    response = await supabase
        .from('topic')
        .select('*')
        .eq('teacher_course_id', teacherCourse.first['id']);
  } else {
    response =
        await supabase.from('topic').select('*').eq('super_topic_id', topicId);
  }

  List<Topic> updatedTopics = [];
  for (var t in response) {
    var topic = Topic.fromJson(t);
    Media? media = await doesTopicHasMedia(topic.id);
    topic.isTopicFinal = media != null;
    topic.media = media;
    updatedTopics.add(topic);
  }

  // Update the cache asynchronously
  cacheBox.put(
      cacheKey, jsonEncode(updatedTopics.map((topic) => topic.toJson()).toList()));
}

Future<Media?> doesTopicHasMedia(int topicId) async {
  final response =
      await supabase.from('media').select("*").eq('topic_id', topicId);
  if (response.isEmpty) {
    return null;
  }
  Media media = Media.fromJson(response.first);
  return media;
}
