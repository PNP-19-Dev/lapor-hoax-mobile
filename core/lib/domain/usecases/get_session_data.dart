import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../entities/session_data.dart';
import '../repositories/repository.dart';

class GetSessionData {
  final Repository repository;

  GetSessionData(this.repository);

  Future<Either<Failure, SessionData?>> execute() {
    return repository.getSessionData();
  }
}
