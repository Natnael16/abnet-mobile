import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/paths.dart';
import '../../../../core/shared_widgets/custom_drawer.dart';
import '../../../../core/shared_widgets/custom_textfield.dart';
import '../../../../core/shared_widgets/no_data_reload.dart';
import '../../../../core/utils/images.dart';
import '../../data/models/teacher.dart';
import '../bloc/teachers/teachers_bloc.dart';
import '../widgets/intro_text.dart';
import '../widgets/navigational_button.dart';
import '../widgets/shimmer_list.dart';

class TeachersPage extends StatefulWidget {
  final int courseId;
  final String courseTitle;
  const TeachersPage({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  TextEditingController searchController = TextEditingController();
  List<Teacher> allTeachers = [];
  List<Teacher> filteredTeachers = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TeachersBloc>(context)
        .add(GetTeachersEvent(courseId: widget.courseId));
    searchController.addListener(() {
      filterTeachers();
    });
  }

  void filterTeachers() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredTeachers = allTeachers
          .where((teacher) => teacher.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ዜማ ያሬድ",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
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
                child: SvgPicture.asset(AppImages.searchIcon,
                    width: 22, height: 22),
              ),
              controller: searchController,
            ),
            const SizedBox(height: 16),
            BlocConsumer<TeachersBloc, TeachersState>(
              listener: (context, state) {
                if (state is TeachersSuccess) {
                  setState(() {
                    allTeachers = state.teachers;
                    filteredTeachers = allTeachers;
                  });
                }
              },
              builder: (context, state) {
                if (state is TeachersLoading) {
                  return const ShimmerList();
                } else if (state is TeachersSuccess) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredTeachers.isNotEmpty
                        ? filteredTeachers.length
                        : 1,
                    itemBuilder: (context, index) {
                      if (filteredTeachers.isEmpty) {
                        return NoDataReload(
                          onPressed: () {
                            BlocProvider.of<TeachersBloc>(context).add(
                                GetTeachersEvent(courseId: widget.courseId));
                          },
                        );
                      }
                      final teacher = filteredTeachers[index];
                      return NavigationalButton(
                        title: teacher.name, // Use the original title
                        onPressed: () {
                          context.push(AppPaths.topics, extra: {
                            'courseId': widget.courseId,
                            "title": teacher.name,
                            "teacherId": teacher.id,
                          });
                        },
                        searchQuery: searchController
                            .text, // Pass the search query for highlighting
                      );
                    },
                  );
                }
                return NoDataReload(
                  onPressed: () {
                    BlocProvider.of<TeachersBloc>(context)
                        .add(GetTeachersEvent(courseId: widget.courseId));
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
