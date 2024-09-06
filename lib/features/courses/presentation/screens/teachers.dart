import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/shared_widgets/custom_textfield.dart';
import '../../../../core/shared_widgets/no_data_reload.dart';
import '../../../../core/utils/images.dart';
import '../../data/models/course.dart';
import '../../data/models/teacher.dart';
import '../bloc/course/course_bloc.dart';
import '../bloc/teachers/teachers_bloc.dart';
import '../widgets/intro_text.dart';
import '../widgets/navigational_button.dart';
import '../widgets/shimmer_list.dart';

class TeachersPage extends StatefulWidget {
  final int courseId;
  final String courseTitle;
  const TeachersPage(
      {super.key, required this.courseId, required this.courseTitle});

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  @override
  initState() {
    BlocProvider.of<TeachersBloc>(context)
        .add(GetTeachersEvent(courseId: widget.courseId));
    super.initState();
  }

  TextEditingController searchController = TextEditingController();
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
              IntroText(title: widget.courseTitle),
              const SizedBox(height: 16),
              SearchTextField(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: SvgPicture.asset(AppImages.searchIcon,width:22,height:22),
                  ),
                  controller: searchController),
              const SizedBox(height: 16),
              BlocConsumer<TeachersBloc, TeachersState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is TeachersLoading) {
                    return const ShimmerList();
                  } else if (state is TeachersSuccess) {
                    final List<Teacher> teachers =
                        state.teachers; // Assuming state has a list of courses

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: teachers.length,
                      itemBuilder: (context, index) {
                        final teacher = teachers[index];

                        return NavigationalButton(
                          title: teacher.name, // Use course title
                          onPressed: () {
                            // Handle button press, e.g., navigate to course detail page
                            print("Teacher ID:  ${teacher.id}");
                          
                            // Add your navigation logic here
                          },
                        );
                      },
                    );
                  }
                  return NoDataReload(
                    onPressed: () {},
                  );
                },
              )
            ],
          ),
        ));
  }
}
