import 'package:abnet_mobile/core/routes/paths.dart';
import 'package:abnet_mobile/features/courses/presentation/screens/courses.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/courses/presentation/screens/media_player.dart';
import '../../features/courses/presentation/screens/teachers.dart';
import '../../features/courses/presentation/screens/topics.dart';
import '../../features/splash/splash_screen.dart';
import '../utils/theme.dart';

class AppRouter extends StatelessWidget {
  static final GoRouter _router = GoRouter(
    initialLocation: AppPaths.splash,
    routes: <GoRoute>[
      GoRoute(
        path: AppPaths.splash,
        builder: (BuildContext context, GoRouterState state) =>
            const SplashPage(),
      ),
      GoRoute(
        path: AppPaths.courses,
        builder: (BuildContext context, GoRouterState state) =>
            const CoursesPage(),
      ),
      GoRoute(
          path: AppPaths.teachers,
          builder: (BuildContext context, GoRouterState state) {
            var extra = state.extra as Map<String, dynamic>;
            return TeachersPage(
                courseId: extra['courseId'], courseTitle: extra['courseTitle']);
          }),
      GoRoute(
          path: AppPaths.topics,
          builder: (BuildContext context, GoRouterState state) {
            var extra = state.extra as Map<String, dynamic>;
            return TopicsPage(
                courseId: extra['courseId'],
                title: extra['title'],
                teacherId: extra['teacherId'],
                superTopicId: extra['superTopicId']);
          }),
      GoRoute(
          path: AppPaths.mediaPlayer,
          builder: (BuildContext context, GoRouterState state) {
            var extra = state.extra as Map<String, dynamic>;
            return MediaPlayerPage(media: extra['media']);
          }),
    ],
  );

  const AppRouter({super.key});

  GoRouter get router => _router;

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        theme: appTheme,
      );
}
