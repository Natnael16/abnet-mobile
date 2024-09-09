import '../../../../main.dart';
import '../models/media.dart';
import '../models/topic.dart';


Future<List<Topic>> getTopics(int courseId, int teacherId, int? topicId) async {
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
  List<Topic> topics = [];
  for (var t in response) {
    var topic = Topic.fromJson(t);
    Media? media = await doesTopicHasMedia(topic.id);
    topic.isTopicFinal = media != null;
    topic.media = media;
    topics.add(topic);
  }
  return topics;
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
