import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/paths.dart';
import '../../../../core/shared_widgets/constrained_scaffold.dart';
import '../../../../core/shared_widgets/custom_drawer.dart';
import '../../../../core/shared_widgets/no_data_reload.dart';
import '../../data/models/course.dart';
import '../bloc/course/course_bloc.dart';
import '../widgets/course_card.dart'; // Import the CourseCard widget
import '../widgets/intro_text.dart';
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
    return ConstrainedScaffold(
      hasBack: false,
      body: Column(
        children: [
          const IntroText(title: "የትምህርቶች ዝርዝር"),
          const SizedBox(height: 16),
          BlocConsumer<CourseBloc, CourseState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is CourseLoading) {
                return const ShimmerList();
              } else if (state is CourseSuccess) {
                final List<Course> courses = state.courses;
      
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Adjust the number of columns
                    childAspectRatio: 1, // Adjust aspect ratio for card
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
      
                    return CourseCard(
                      title: course.title, // Use course title
                      iconPath:
                          'assets/icons/${course.title}.svg', // Local icon path
                      onPressed: () {
                        context.push(AppPaths.teachers, extra: {
                          'courseId': course.id,
                          "courseTitle": course.title
                        });
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
          ),
        ],
      ),
    );
  }
}
