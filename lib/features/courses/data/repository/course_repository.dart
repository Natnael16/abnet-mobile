// import 'package:dartz/dartz.dart';

// import '../../../../core/error/failure.dart';
// import '../datasource/course_datasource.dart';
// import '../models/course.dart';

// abstract class CoursesRepository {
//   Future<Either<Failure, List<Course>>> getCourses();
// }

// class CoursesRepositoryImpl implements CoursesRepository {
//   final CoursesRemoteDataSource dataSource;
//   CoursesRepositoryImpl(this.dataSource);
  
//   @override
//   Future<Either<Failure, List<Course>>> getCourses() async {
//      try {
//       final List<Course> result =
//           await dataSource.getCourses();
//       return Right(result);
//     } catch (e) {
//       return Left(ServerFailure(e.toString()));
//     }
//   }

// }
