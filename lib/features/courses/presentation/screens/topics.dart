import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/paths.dart';
import '../../../../core/shared_widgets/custom_textfield.dart';
import '../../../../core/shared_widgets/no_data_reload.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/images.dart';
import '../../../../main.dart';
import '../../data/models/topic.dart';
import '../bloc/media/media_bloc.dart';
import '../bloc/topics/topics_bloc.dart';
import '../widgets/floating_player.dart';
import '../widgets/intro_text.dart';
import '../widgets/navigational_button.dart';
import '../widgets/persistent_bottom_sheet.dart';
import '../widgets/shimmer_list.dart';

class TopicsPage extends StatefulWidget {
  final int courseId;
  final String title;
  final int teacherId;
  final int? superTopicId;
  const TopicsPage(
      {super.key,
      required this.courseId,
      required this.title,
      required this.teacherId,
      this.superTopicId});

  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  @override
  initState() {
    super.initState();

    BlocProvider.of<TopicsBloc>(context).add(GetTopicsEvent(
        courseId: widget.courseId,
        teacherId: widget.teacherId,
        superTopicId: widget.superTopicId));
  }

  TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                  controller: searchController),
              const SizedBox(height: 16),
              BlocConsumer<TopicsBloc, TopicsState>(
                listener: (context, state) {
                  if (state is ClearTopicsState) {
                    BlocProvider.of<TopicsBloc>(context).add(GetTopicsEvent(
                        courseId: widget.courseId,
                        teacherId: widget.teacherId,
                        superTopicId: widget.superTopicId));
                  }
                },
                builder: (context, state) {
                  if (state is TopicsLoading) {
                    return const ShimmerList();
                  } else if (state is TopicsSuccess) {
                    final List<Topic> topics = state.topics;

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: topics.length,
                      itemBuilder: (context, index) {
                        final topic = topics[index];

                        return NavigationalButton(
                          title: topic.title,
                          suffix: topic.isTopicFinal
                              ? const Icon(Icons.play_circle_rounded,
                                  color: AppColors.primaryColor, size: 30)
                              : null,
                          onPressed: () {
                            if (topic.isTopicFinal) {
                              context
                                  .read<AudioBloc>()
                                  .add(PlayAudio(topic.media!.audioUrl!));
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
                  }
                  return NoDataReload(
                    onPressed: () {
                      BlocProvider.of<TopicsBloc>(context).add(GetTopicsEvent(
                          courseId: widget.courseId,
                          teacherId: widget.teacherId,
                          superTopicId: widget.superTopicId));
                    },
                  );
                },
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: const FloatingAudioPlayer(),
      ),
    );
  }
}
