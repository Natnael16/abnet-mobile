import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/shared_widgets/custom_drawer.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // Dropdown selections
  String selectedCourseType = "Nibab bet";
  String selectedTeacher = "Memhr nekea tibeb";
  String selectedSection = "Wudase Mariam";
  String selectedSubSection = "Zesenuy";

  List<String> courseTypes = ["Nibab bet", "Yetmhret aynet", "Type 3"];
  List<String> teachers = ["Memhr nekea tibeb", "Memhr 2", "Memhr 3"];
  List<String> sections = ["Wudase Mariam", "Section 2", "Section 3"];
  List<String> subSections = ["Zesenuy", "Sub Section 2", "Sub Section 3"];

  String? _documentFileName;
  String? _mediaFileName;

  // Function to add a new item to dropdown if not found
  Future<void> _addNewItemDialog(String itemType) async {
    String newItem = '';
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add new $itemType'),
          content: TextField(
            onChanged: (value) {
              newItem = value;
            },
            decoration: InputDecoration(hintText: 'Enter new $itemType'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (itemType == "course type") {
                    courseTypes.add(newItem);
                    selectedCourseType = newItem;
                  } else if (itemType == "teacher") {
                    teachers.add(newItem);
                    selectedTeacher = newItem;
                  } else if (itemType == "section") {
                    sections.add(newItem);
                    selectedSection = newItem;
                  } else if (itemType == "subsection") {
                    subSections.add(newItem);
                    selectedSubSection = newItem;
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // File pickers
  Future<void> _pickDocumentFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _documentFileName = result.files.first.name;
      });
    }
  }

  Future<void> _pickMediaFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'mp4', 'mp3'],
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
        title: const Text("ረቡኒ",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Admin to header
              Text(
                'አስፈላጊውን መረጃ ያስገቡ',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              

              // Dropdown for course type
              _dropdownField(
                'Course Type',
                selectedCourseType,
                courseTypes,
                (newValue) {
                  setState(() {
                    selectedCourseType = newValue!;
                  });
                },
                () => _addNewItemDialog("course type"),
              ),
              SizedBox(height: 3.h),

              // Dropdown for teachers
              _dropdownField(
                'Teacher',
                selectedTeacher,
                teachers,
                (newValue) {
                  setState(() {
                    selectedTeacher = newValue!;
                  });
                },
                () => _addNewItemDialog("teacher"),
              ),
              SizedBox(height: 3.h),

              // Dropdown for sections
              _dropdownField(
                'Section',
                selectedSection,
                sections,
                (newValue) {
                  setState(() {
                    selectedSection = newValue!;
                  });
                },
                () => _addNewItemDialog("section"),
              ),
              SizedBox(height: 3.h),

              // Dropdown for subsections
              _dropdownField(
                'Sub Section',
                selectedSubSection,
                subSections,
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
              // Upload document file
              _uploadSection('Upload documents file', _pickDocumentFile,
                  _documentFileName),
              SizedBox(height: 3.h),

              // Upload audio or video file
              _uploadSection(
                  'Upload Audio or Video file', _pickMediaFile, _mediaFileName),
              SizedBox(height: 5.h),

              // Back and Next buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _button('Back', Colors.grey, () {
                    Navigator.pop(context);
                  }),
                  _button('Next', Colors.green, () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable dropdown widget
  Widget _dropdownField(String label, String selectedItem, List<String> items,
      ValueChanged<String?> onChanged, VoidCallback onAddNew) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: DropdownButton<String>(
                value: selectedItem,
                isExpanded: true,
                onChanged: onChanged,
                items: items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_circle_outline, size: 24.sp),
              onPressed: onAddNew,
            ),
          ],
        ),
      ],
    );
  }

  // Reusable upload section
  Widget _uploadSection(
      String title, VoidCallback onPickFile, String? fileName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: onPickFile,
          child: Container(
            height: 25.h,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline, size: 8.h, color: Colors.grey),
                  SizedBox(height: 2.h),
                  Text(
                    fileName ??
                        'Drag and drop a pdf, doc, docx, or image file (jpg, jpeg)',
                    style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Reusable button widget
  Widget _button(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(40.w, 6.h),
      ),
      child: Text(text, style: TextStyle(fontSize: 16.sp)),
    );
  }
}
