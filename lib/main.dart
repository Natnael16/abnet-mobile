import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'core/injections/injection_container.dart';
import 'core/routes/router_config.dart';
import 'core/utils/bloc_observer.dart';
import 'core/utils/theme.dart';
import 'features/admin/presentation/bloc/upload/upload_bloc.dart';
import 'features/courses/presentation/bloc/course/course_bloc.dart';
import 'features/courses/presentation/bloc/media/media_bloc.dart';
import 'features/courses/presentation/bloc/teachers/teachers_bloc.dart';
import 'features/courses/presentation/bloc/topics/topics_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['ANON_KEY'] ?? '',
  );
  await injectionInit();
  await Hive.initFlutter();
  await Hive.openBox('cacheBox');
  await Hive.openBox('audioCache');
  Bloc.observer = MyGlobalObserver();
  await JustAudioBackground.init(
    androidNotificationChannelId: "com.ryanheise.bg_demo.channel.audio",
    androidNotificationChannelName: "Audio playback",
    androidNotificationOngoing: true,
  );
  runApp(ResponsiveSizer(
    builder: (context, orientation, screenType) {
      return Builder(builder: (context) {
        return AdaptiveTheme(
          light: appTheme, // Your custom light theme
            dark: darkTheme, // Define your custom dark theme
            initial: AdaptiveThemeMode.light,
            builder: (theme, darkTheme) => MultiBlocProvider(
                  providers: [
                    BlocProvider<CourseBloc>(create: (_) => CourseBloc()),
                    BlocProvider<TeachersBloc>(create: (_) => TeachersBloc()),
                    BlocProvider<TopicsBloc>(create: (_) => TopicsBloc()),
                    BlocProvider<AudioBloc>(create: (_) => AudioBloc()),
                    BlocProvider<UploadBloc>(create: (_) => UploadBloc())
                  ],
                  child: MyApp(),
                ));
      });
    },
  ));
}
//Global variables

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
