import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/paths.dart';
import '../../../../core/shared_widgets/no_data_reload.dart';
import '../../data/models/course.dart';
import '../bloc/course/course_bloc.dart';
import '../widgets/floating_player.dart';
import '../widgets/intro_text.dart';
import '../widgets/navigational_button.dart';
import '../widgets/shimmer_list.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  initState() {
    BlocProvider.of<CourseBloc>(context).add(GetCoursesEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const IntroText(title: "የትምህርቶች ዝርዝር"),
            const SizedBox(height: 16),
            BlocConsumer<CourseBloc, CourseState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is CourseLoading) {
                  return const ShimmerList();
                } else if (state is CourseSuccess) {
                  final List<Course> courses =
                      state.courses; // Assuming state has a list of courses

                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];

                      return NavigationalButton(
                        title: course.title, // Use course title
                        onPressed: () {
                          context.push(AppPaths.teachers, extra: {
                            'courseId': course.id,
                            "courseTitle": course.title
                          });
                          // Add your navigation logic here
                        },
                      );
                    },
                  );
                }
                return NoDataReload(
                  onPressed: () {
                    BlocProvider.of<CourseBloc>(context).add(GetCoursesEvent());
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
