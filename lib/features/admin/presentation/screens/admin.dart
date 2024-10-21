import 'dart:io' as io;
import 'dart:typed_data';

import 'package:abnet_mobile/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/shared_widgets/constrained_scaffold.dart';
import '../../../../core/shared_widgets/custom_loading_widget.dart';
import '../../../../core/shared_widgets/custom_round_button.dart';
import '../../../../core/shared_widgets/toasts.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/file_uploader_service.dart';
import '../../../courses/data/datasource/courses_datasource.dart';
import '../../../courses/data/datasource/teachers_datasource.dart';
import '../../../courses/data/datasource/topics_datasource.dart';
import '../../../courses/data/models/course.dart';
import '../../../courses/data/models/teacher.dart';
import '../../../courses/data/models/topic.dart';
import '../bloc/upload/upload_bloc.dart';
import '../widgets/dropdown_field.dart';
import '../widgets/upload_section.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  AdminPageState createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  // Dropdown selections
  Course? selectedCourseType;
  Teacher? selectedTeacher;
  Topic? selectedTopic;
  List<Topic> subTopics = [];
  int maxSubTopics = 4;

  // Updated lists to use Course, Teacher, and Topic classes
  List<Course> courseTypes = [];
  List<Teacher> teachers = [];
  List<Topic> topics = [];
  List<String> docTypes = SUPPORTED_DOC_TYPES;
  List<String> mediaTypes = SUPPORTED_MEDIA_TYPES;
  Map<String, dynamic>? uploadedDocumentFileInfo;
  Map<String, dynamic>? uploadedMediaFileInfo;

  // Fetch data for dropdowns
  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    try {
      courseTypes = await getCourses();
      teachers = await getTeachers();
      topics = await getAllTopics();
      setState(() {
        selectedCourseType = courseTypes.first;
        selectedTeacher = teachers.first;
        selectedTopic = topics.first;
      });
    } catch (e) {
      debugPrint("Error initializing dropdowns: $e");
    }
    setState(() {}); // Refresh the UI with the fetched data
  }

  void onSubmit() {
    if (selectedCourseType == null ||
        selectedTeacher == null ||
        selectedTopic == null ||
        uploadedMediaFileInfo == null 
        ) {
      Fluttertoast.showToast(
          webShowClose: true,
          msg: "ሁሉንም አስፈላጊ መረጃ አስገብተው እንደገና ይሞክሩ",
          timeInSecForIosWeb: 10,
          webBgColor: AppColors.bgErrorColor);
      return;
    }
    BlocProvider.of<UploadBloc>(context).add(UploadEvent(
        course: selectedCourseType!,
        teacher: selectedTeacher!,
        topic: selectedTopic!,
        topics: subTopics,
        document: uploadedDocumentFileInfo,
        media: uploadedMediaFileInfo!));
  }

  void _addSubtopic() {
    if (subTopics.length < maxSubTopics) {
      setState(() {
        subTopics.add(topics[0]);
      });
    }
  }

  // Function to add a course
  Future<void> addCourse(String courseTitle) async {
    if (courseTitle.isNotEmpty) {
      try {
        Course? newCourse = await createCourse(courseTitle);

        if (newCourse != null) {
          setState(() {
            courseTypes.add(newCourse);
            selectedCourseType = newCourse;
          });
          Fluttertoast.showToast(
            webShowClose: true,
            msg: "አዲስ ትምህርት በተሳካ ሁኔታ ተመዝግቧል",
            timeInSecForIosWeb: 5,
            backgroundColor: AppColors.primaryColor,
          );
        } else {
          Fluttertoast.showToast(
              webShowClose: true,
              msg: "አልተሳካም እንደገና ይሞክሩ",
              timeInSecForIosWeb: 10,
              webBgColor: AppColors.bgErrorColor);
        }
      } catch (e) {
        Fluttertoast.showToast(
            webShowClose: true,
            msg: "አልተሳካም እንደገና ይሞክሩ",
            timeInSecForIosWeb: 10,
            webBgColor: AppColors.bgErrorColor);
      }
    }
  }

  // Function to add a teacher
  Future<void> addTeacher(String teacherName) async {
    try {
      Teacher? newTeacher = await createTeacher(teacherName);
      if (newTeacher != null) {
        setState(() {
          teachers.add(newTeacher);
          selectedTeacher = newTeacher;
        });
        Fluttertoast.showToast(
          webShowClose: true,
          msg: "አዲስ መምህር በተሳካ ሁኔታ ተመዝግቧል",
          timeInSecForIosWeb: 10,
          backgroundColor: AppColors.primaryColor,
        );
      } else {
        Fluttertoast.showToast(
          webShowClose: true,
          msg: "አልተሳካም እንደገና ይሞክሩ",
          timeInSecForIosWeb: 10,
          backgroundColor: AppColors.primaryColor,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
          webShowClose: true,
          msg: "አልተሳካም እንደገና ይሞክሩ",
          timeInSecForIosWeb: 10,
          webBgColor: AppColors.bgErrorColor);
    }
  }

  // Function to add a topic
  Future<void> addTopic(String topicTitle, int? subTopicIndex) async {
    try {
      Topic? newTopic = await createTopic(topicTitle);
      if (newTopic != null) {
        setState(() {
          topics.add(newTopic);
          if (subTopicIndex != null) {
          } else {
            selectedTopic = newTopic;
          }
        });
        Fluttertoast.showToast(
          webShowClose: true,
          msg: "አዲስ ክፍል በተሳካ ሁኔታ ተመዝግቧል",
          timeInSecForIosWeb: 10,
          backgroundColor: AppColors.primaryColor,
        );
      } else {
        Fluttertoast.showToast(
            webShowClose: true,
            msg: "አልተሳካም እንደገና ይሞክሩ",
            timeInSecForIosWeb: 10,
            webBgColor: AppColors.bgErrorColor);
      }
    } catch (e) {
      Fluttertoast.showToast(
          webShowClose: true,
          msg: "አልተሳካም እንደገና ይሞክሩ",
          webBgColor: AppColors.bgErrorColor);
    }
  }

  Future<void> _addNewItemDialog(String itemType, {int? subTopicIndex}) async {
    String newItem = '';
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('አዲስ $itemType ይጨምሩ'),
          content: TextField(
            onChanged: (value) {
              newItem = value;
            },
            decoration: InputDecoration(hintText: 'አዲስ $itemType ይጨምሩ'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ተመለስ'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (itemType == "የትምህርት አይነት") {
                  await addCourse(newItem);
                } else if (itemType == "መምህር") {
                  await addTeacher(newItem);
                } else if (itemType == "ክፍል") {
                  await addTopic(newItem, subTopicIndex);
                }
              },
              child: Text('መዝግብ'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickFile(allowedExtensions, type) async {
    try {
      var fileDict =
          await FilePickerService.getFile(allowedExtensions: allowedExtensions);

      if (fileDict != null && fileDict['file'] is Uint8List) {
        setState(() {
          if (type == 'doc') {
            uploadedDocumentFileInfo = fileDict;
          } else {
            uploadedMediaFileInfo = fileDict;
          }
        });
      } else if (fileDict != null && fileDict['file'] is io.File) {
        // Mobile/Desktop: Handle File object

        setState(() {
          if (type == 'doc') {
            uploadedDocumentFileInfo;
          } else {
            uploadedMediaFileInfo;
          }
        });
      }
    } catch (e) {
      debugPrint('File Picking error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'አስፈላጊውን መረጃ ያስገቡ',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 3.h,
              ),
              // Dropdown for course type
              dropdownField(
                'የትምህርት አይነት',
                selectedCourseType,
                courseTypes,
                (dynamic newValue) {
                  setState(() {
                    selectedCourseType = newValue;
                  });
                },
                () => _addNewItemDialog("የትምህርት አይነት"),
              ),
              SizedBox(height: 3.h),

              // Dropdown for teachers
              dropdownField(
                'መምህር',
                selectedTeacher,
                teachers,
                (newValue) {
                  setState(() {
                    selectedTeacher = newValue! as Teacher;
                  });
                },
                () => _addNewItemDialog("መምህር"),
              ),
              SizedBox(height: 3.h),

              // Dropdown for sections
              dropdownField(
                'ክፍል',
                selectedTopic,
                topics,
                (newValue) {
                  setState(() {
                    selectedTopic = newValue as Topic;
                  });
                },
                () => _addNewItemDialog("ክፍል"),
              ),
              SizedBox(height: 3.h),

              Column(
                children: subTopics.asMap().entries.map((entry) {
                  int index = entry.key;
                  return Column(
                    children: [
                      dropdownField(
                        'ንዑስ ክፍል ${index + 1}',
                        subTopics[index],
                        topics,
                        (newValue) {
                          setState(() {
                            subTopics[index] = newValue as Topic;
                          });
                        },
                        () => _addNewItemDialog("ክፍል", subTopicIndex: index),
                      ),
                      SizedBox(height: 3.h),
                    ],
                  );
                }).toList(),
              ),

              // Button to add new subtopic dropdown
              if (subTopics.length < maxSubTopics)
                TextButton.icon(
                  onPressed: _addSubtopic,
                  icon: const Icon(Icons.add),
                  label: const Text('ንዑስ ክፍል ጨምር'),
                ),
              SizedBox(height: 3.h),

              // Display selected hierarchy
              Text(
                'የመረጡት ቅደም ተከተል ይህን ይመስላል',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2.h),
              Text(
                '${selectedCourseType?.title ?? ""} -> ${selectedTeacher?.name ?? ""} -> ${selectedTopic?.title ?? ""} -> ${subTopics.map((obj) => obj?.title).join(' -> ')}',
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(height: 3.h),
              uploadSection(
                  'የንባቡን/የዜማውን ዘር/ምልክት ያስገቡ',
                  () => _pickFile(docTypes, 'doc'),
                  uploadedDocumentFileInfo?['name'],
                  docTypes),
              SizedBox(height: 5.h),

              uploadSection(
                  'የዜማውን/የንባቡ/የተንቀሳቃሽ ምስሉን ያስገቡ',
                  () => _pickFile(mediaTypes, 'media'),
                  uploadedMediaFileInfo?['name'],
                  mediaTypes),
              SizedBox(height: 5.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocConsumer<UploadBloc, UploadState>(
                    listener: (context, state) {
                      if (state is UploadFailure) {
                        errorSavingToast();
                      } else if (state is UploadSuccess) {
                        savedSuccessToast();
                      }
                    },
                    builder: (context, state) {
                      if (state is UploadLoading) {
                        return const CustomLoadingWidget();
                      }
                      return CustomRoundButton(
                          buttonText: "መዝግብ", onPressed: onSubmit);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
