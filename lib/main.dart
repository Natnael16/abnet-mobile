import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/injections/injection_container.dart';
import 'core/routes/router_config.dart';
import 'core/utils/bloc_observer.dart';
import 'features/courses/presentation/bloc/course/course_bloc.dart';
import 'features/courses/presentation/bloc/teachers/teachers_bloc.dart';

void main() async {
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['ANON_KEY'] ?? '',
  );
  await injectionInit();
  Bloc.observer = MyGlobalObserver();
  runApp(ResponsiveSizer(
    builder: (context, orientation, screenType) {
      return MultiBlocProvider(
        providers: [
           BlocProvider<CourseBloc>(create: (_) => CourseBloc()),
           BlocProvider<TeachersBloc>(create: (_) => TeachersBloc())
        ],
        child: const MyApp(),
      );
    },
  ));
}

final supabase = Supabase.instance.client;

final isLoggedIn =
    supabase.auth.currentSession != null; // Retrieve the current session data

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return AppRouter();
  }
}
