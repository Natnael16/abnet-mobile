import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/paths.dart';
import '../../../../core/shared_widgets/custom_textfield.dart';
import '../../../../core/shared_widgets/no_data_reload.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/images.dart';
import '../../data/models/topic.dart';
import '../bloc/topics/topics_bloc.dart';
import '../widgets/intro_text.dart';
import '../widgets/navigational_button.dart';
import '../widgets/shimmer_list.dart';

class TopicsPage extends StatefulWidget {
  final int courseId;
  final String title;
  final int teacherId;
  final int? superTopicId;
  const TopicsPage({
    super.key,
    required this.courseId,
    required this.title,
    required this.teacherId,
    this.superTopicId,
  });

  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Topic> allTopics = []; // Store all topics
  List<Topic> filteredTopics = []; // Store filtered topics

  @override
  void initState() {
    super.initState();

    // Fetch topics on initialization
    BlocProvider.of<TopicsBloc>(context).add(GetTopicsEvent(
      courseId: widget.courseId,
      teacherId: widget.teacherId,
      superTopicId: widget.superTopicId,
    ));

    // Listen to changes in the search text field
    searchController.addListener(() {
      filterTopics();
    });
  }

  void filterTopics() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredTopics = allTopics
          .where((topic) => topic.title.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TopicsBloc()
        ..add(GetTopicsEvent(
          courseId: widget.courseId,
          teacherId: widget.teacherId,
          superTopicId: widget.superTopicId,
        )),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text("ረቡኒ",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
          centerTitle: true,
        ),
        drawer: const Drawer(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              IntroText(title: widget.title),
              const SizedBox(height: 16),
              SearchTextField(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: SvgPicture.asset(AppImages.searchIcon,
                      width: 22, height: 22),
                ),
                controller: searchController,
              ),
              const SizedBox(height: 16),
              BlocConsumer<TopicsBloc, TopicsState>(
                listener: (context, state) {
                  if (state is TopicsSuccess) {
                    setState(() {
                      allTopics = state.topics; // Store all topics
                      filteredTopics = allTopics; // Initialize filtered topics
                    });
                  }
                },
                builder: (context, state) {
                  if (state is TopicsLoading) {
                    return const ShimmerList();
                  } else if (state is TopicsSuccess) {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredTopics.isNotEmpty
                          ? filteredTopics.length
                          : 1, // Show "No Data" if no filtered topics
                      itemBuilder: (context, index) {
                        if (filteredTopics.isEmpty) {
                          return NoDataReload(
                            onPressed: () {
                              BlocProvider.of<TopicsBloc>(context).add(
                                GetTopicsEvent(
                                  courseId: widget.courseId,
                                  teacherId: widget.teacherId,
                                  superTopicId: widget.superTopicId,
                                ),
                              );
                            },
                          );
                        }
                        final topic = filteredTopics[index];
                        return NavigationalButton(
                          title: topic.title,
                          searchQuery: searchController.text,
                          suffix: topic.isTopicFinal
                              ? const Icon(Icons.play_circle_rounded,
                                  color: AppColors.primaryColor, size: 30)
                              : null,
                          onPressed: () {
                            if (topic.isTopicFinal) {
                              context.push(AppPaths.mediaPlayer, extra: {
                                'media': topic.media,
                              });
                            } else {
                              context.push(AppPaths.topics, extra: {
                                'courseId': widget.courseId,
                                "title": topic.title,
                                "teacherId": widget.teacherId,
                                "superTopicId": topic.id,
                              });
                            }
                          },
                        );
                      },
                    );
                  } else {
                    // Handle failure state
                    return NoDataReload(
                      onPressed: () {
                        BlocProvider.of<TopicsBloc>(context).add(GetTopicsEvent(
                          courseId: widget.courseId,
                          teacherId: widget.teacherId,
                          superTopicId: widget.superTopicId,
                        ));
                      },
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
