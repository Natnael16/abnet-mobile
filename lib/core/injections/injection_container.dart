import 'package:get_it/get_it.dart';

import '../../main.dart';

var getIt = GetIt.instance;

Future<void> injectionInit() async {
  //! Common

  getIt.registerLazySingleton(() => supabase);
}
