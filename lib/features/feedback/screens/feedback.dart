import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
import '../../../core/shared_widgets/custom_loading_widget.dart';
import '../../../core/shared_widgets/custom_round_button.dart';
import '../../../core/utils/colors.dart';
import '../../../main.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('አስተያየት'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.defaultGrey, // Set your color here
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'አስተያየት',
                    hintStyle: TextStyle(
                        color: Colors.black54), // Change label color if needed
                    border: InputBorder.none, // Remove border
                    contentPadding:
                        EdgeInsets.all(16), // Padding inside the text field
                  ),
                ),
              ),
              const SizedBox(height: 40),
              if (!isLoading)
                CustomRoundButton(
                  borderRadius: 25,
                  buttonText: "አስተያየት ስጥ",
                  onPressed: () async {
                    // Handle feedback submission
                    final feedback = _controller.text;
                    if (feedback.isNotEmpty) {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await supabase.from('feedback').insert({
                          'description': feedback,
                        }); // Replace with your column name

                        // Show success dialog
                        _showDialog(context, 'አስተያየቶን ስለሰጡን እጅግ እናመሰግናለን።');
                        _controller.clear();
                      } catch (e) {
                        _showDialog(context, 'አባክዎን እንደገና ይሞክሩ');

                        debugPrint(e.toString());
                      }

                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                )
              else
                const CustomLoadingWidget()
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(message, style: const TextStyle(fontSize: 20)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('ተመለስ'),
            ),
          ],
        );
      },
    );
  }
}
