import '../../../../core/utils/supabase_bucket.dart';
import '../../../../main.dart';
import '../models/course.dart';
import '../models/teacher.dart';
import '../models/topic.dart';

Future<bool> createDocument(
    {required Course course,
    required Teacher teacher,
    required Topic topic,
    required List<Topic> subTopics,
    Map? doc,
    required Map media}) async {
  final uploadResult = await uploadCourseDocuments(doc, media);
  if (uploadResult['error'] == null) {
    // Create Teacher Course relation if not exsist
    int teacherCourseId;
    final teacherCourse = await supabase
        .from('teacher_course')
        .select('id')
        .eq('course_id', course.id)
        .eq('teacher_id', teacher.id);

    if (teacherCourse.isEmpty) {
      final tcResult = await supabase.from('teacher_course').insert({
        "course_id": course.id,
        "teacher_id": teacher.id,
      }).select('id');
      teacherCourseId = tcResult.first['id'];
    } else {
      teacherCourseId = teacherCourse.first['id'];
    }
    // update or create topic
    final topicSearch = await supabase
        .from('topic')
        .select('teacher_course_id')
        .eq('title', topic.title)
        .eq('teacher_course_id', teacherCourseId);
    if (topicSearch.isEmpty) {
      await supabase
          .from('topic')
          .update({'teacher_course_id': teacherCourseId}).eq('id', topic.id);
    }

    Topic lastTopic = topic;

    for (var t in subTopics) {
      await supabase
          .from('topic')
          .update({'super_topic_id': lastTopic.id}).eq('id', t.id);
      lastTopic = t;
    }

    // create the media
    List<String> mediaTypes = ['audio'];
    if (uploadResult['docUrl'] != null) {
      mediaTypes.add('document');
    }

    await supabase.from('media').insert({
      "title": lastTopic.title,
      "topic_id": lastTopic.id,
      "type": mediaTypes,
      "teacher_id": teacher.id,
      "document_url": uploadResult['docUrl'],
      "audio_url": uploadResult['mediaUrl']
    });
    return true;
  }

  return false;
}

Future<Map<String, String?>> uploadCourseDocuments(document, media) async {
  try {
    String? docUrl;
    String? mediaUrl;
    String? error;
    if (document != null) {
      docUrl = await supabaseUpload(
          document['file'], document['name'], 'abnet-media-storage');
    }
    if (media != null) {
      mediaUrl = await supabaseUpload(
          media['file'], media['name'], 'abnet-media-storage');
    }

    if (mediaUrl == null) {
      error = 'Failed to upload media';
    }

    return {'docUrl': docUrl, 'mediaUrl': mediaUrl, 'error': error};
  } catch (e) {
    return {'docUrl': null, 'mediaUrl': null, 'error': e.toString()};
  }
}
