import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/shared_widgets/custom_drawer.dart';
import '../../../../core/shared_widgets/custom_round_button.dart';
import '../../../../core/utils/colors.dart';
import '../../../courses/data/datasource/courses_datasource.dart';
import '../../../courses/data/datasource/teachers_datasource.dart';
import '../../../courses/data/datasource/topics_datasource.dart';
import '../../../courses/data/models/course.dart';
import '../../../courses/data/models/teacher.dart';
import '../../../courses/data/models/topic.dart';
import '../widgets/dropdown_field.dart';
import '../widgets/upload_section.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // Dropdown selections
  String selectedCourseType = "";
  String selectedTeacher = "";
  String selectedSection = "";
  String selectedSubSection = "";

  // Updated lists to use Course, Teacher, and Topic classes
  List<Course> courseTypes = [];
  List<Teacher> teachers = [];
  List<Topic> sections = [];
  List<Topic> subSections = [];
  List<String> docTypes = ['pdf', 'doc', 'docx', 'jpeg', 'jpg', 'png'];
  List<String> mediaTypes = ['mp4', 'mp3'];
  String? _documentFileName;
  String? _mediaFileName;

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
      sections = await getAllTopics();
      // Set default selected values if lists are not empty
      setState(() {
        selectedCourseType =
            courseTypes.isNotEmpty ? courseTypes.first.title : '';
        selectedTeacher = teachers.isNotEmpty ? teachers.first.name : '';
        selectedSection = sections.isNotEmpty ? sections.first.title : '';
      });
    } catch (e) {
      debugPrint("Error initializing dropdowns: $e");
    }
    setState(() {}); // Refresh the UI with the fetched data
  }

  // Function to add a course
  Future<void> addCourse(String courseTitle) async {
    try {
      Course? newCourse = await createCourse(courseTitle);

      if (newCourse != null) {
        setState(() {
          courseTypes.add(newCourse);
          selectedCourseType = newCourse.title;
        });
        Fluttertoast.showToast(
          msg: "አዲስ ትምህርት በተሳካ ሁኔታ ተመዝግቧል",
          backgroundColor: AppColors.primaryColor,
        );
      } else {
        Fluttertoast.showToast(
          msg: "አልተሳካም እንደገና ይሞክሩ",
          backgroundColor: Colors.red.shade400,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "አልተሳካም እንደገና ይሞክሩ",
        backgroundColor: Colors.red.shade400,
      );
    }
  }

  // Function to add a teacher
  Future<void> addTeacher(String teacherName) async {
    try {
      Teacher? newTeacher = await createTeacher(teacherName);
      if (newTeacher != null) {
        setState(() {
          teachers.add(newTeacher);
          selectedTeacher = newTeacher.name;
        });
        Fluttertoast.showToast(
          msg: "አዲስ መምህር በተሳካ ሁኔታ ተመዝግቧል",
          backgroundColor: AppColors.primaryColor,
        );
      } else {
        Fluttertoast.showToast(
          msg: "አልተሳካም እንደገና ይሞክሩ",
          backgroundColor: AppColors.primaryColor,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "አልተሳካም እንደገና ይሞክሩ",
        backgroundColor: Colors.red.shade400,
      );
    }
  }

  // Function to add a topic
  Future<void> addTopic(String topicTitle) async {
    try {
      Topic? newTopic = await createTopic(topicTitle);
      if (newTopic != null) {
        setState(() {
          sections.add(newTopic);
          selectedSection = newTopic.title;
        });
        Fluttertoast.showToast(
          msg: "አዲስ ክፍል በተሳካ ሁኔታ ተመዝግቧል",
          backgroundColor: AppColors.primaryColor,
        );
      } else {
        Fluttertoast.showToast(
          msg: "አልተሳካም እንደገና ይሞክሩ",
          backgroundColor: Colors.red.shade400,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "አልተሳካም እንደገና ይሞክሩ",
        backgroundColor: Colors.red.shade400,
      );
    }
  }

  Future<void> _addNewItemDialog(String itemType) async {
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
                  await addTopic(newItem);
                }
              },
              child: Text('መዝግብ'),
            ),
          ],
        );
      },
    );
  }

  // File pickers
  Future<void> _pickDocumentFile(List<String> types) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: types,
    );

    if (result != null) {
      setState(() {
        _documentFileName = result.files.first.name;
      });
    }
  }

  Future<void> _pickMediaFile(List<String> types) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: types,
    );

    if (result != null) {
      setState(() {
        _mediaFileName = result.files.first.name;
      });
    }
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
              SizedBox(height: 3.h,),
              // Dropdown for course type
              dropdownField(
                'የትምህርት አይነት',
                selectedCourseType,
                courseTypes.map((course) => course.title).toList(),
                (newValue) {
                  setState(() {
                    selectedCourseType = newValue!;
                  });
                },
                () => _addNewItemDialog("የትምህርት አይነት"),
              ),
              SizedBox(height: 3.h),

              // Dropdown for teachers
              dropdownField(
                'መምህር',
                selectedTeacher,
                teachers.map((teacher) => teacher.name).toList(),
                (newValue) {
                  setState(() {
                    selectedTeacher = newValue!;
                  });
                },
                () => _addNewItemDialog("መምህር"),
              ),
              SizedBox(height: 3.h),

              // Dropdown for sections
              dropdownField(
                'ክፍል',
                selectedSection,
                sections.map((section) => section.title).toList(),
                (newValue) {
                  setState(() {
                    selectedSection = newValue!;
                  });
                },
                () => _addNewItemDialog("ክፍል"),
              ),
              SizedBox(height: 3.h),

              // Dropdown for subsections
              dropdownField(
                'Sub Section',
                selectedSubSection,
                subSections.map((subSection) => subSection.title).toList(),
                (newValue) {
                  setState(() {
                    selectedSubSection = newValue!;
                  });
                },
                () => _addNewItemDialog("subsection"),
              ),
              SizedBox(height: 3.h),

              Text(
                'የመረጡት ቅደም ተከተል ይህን ይመስላል',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2.h),
              Text(
                '$selectedCourseType -> $selectedTeacher -> $selectedSection -> $selectedSubSection',
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(height: 3.h),

              uploadSection(
                  'የንባቡን/የዜማውን ዘር/ምልክት ያስገቡ',
                  () => _pickDocumentFile(docTypes),
                  _documentFileName,
                  docTypes),
              SizedBox(height: 3.h),

              uploadSection('የዜማውን/የንባቡ/የተንቀሳቃሽ ምስሉን ያስገቡ',
                  () => _pickMediaFile(mediaTypes), _mediaFileName, mediaTypes),
              SizedBox(height: 5.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomRoundButton(
                      buttonText: "መዝግብ",
                      onPressed: () async {
                        // Add your submission logic here
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
