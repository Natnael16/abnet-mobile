import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/routes/paths.dart';
import '../../../../core/shared_widgets/constrained_scaffold.dart';
import '../../../../main.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool isObsecure = true;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await supabase.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (response.session != null) {
        print("logged in with session: " + response.session.toString());
        context.push(AppPaths.admin);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => UploadingPage()),
        // );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed:')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _contactAdmin() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'natnaeldenbi@gmail.com',
      queryParameters: {'subject': 'Request to be Admin'},
    );
    await launchUrl(emailLaunchUri);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30.h),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              TextField(
                controller: _passwordController,
                obscureText: isObsecure,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  suffixIcon: IconButton(icon:Icon(isObsecure
                            ? Icons.visibility: Icons.visibility_off),onPressed: (){
                    setState(() {
                      isObsecure =!isObsecure;
                    });
                  })
                    
                ),
              ),
              SizedBox(height: 4.h),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 6.h),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Login', style: TextStyle(fontSize: 18.sp)),
              ),
              SizedBox(height: 2.h),
              TextButton(
                onPressed: _contactAdmin,
                child: Text('Want to be an admin? Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
