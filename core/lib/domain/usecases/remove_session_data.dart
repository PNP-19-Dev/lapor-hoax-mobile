import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../entities/session_data.dart';
import '../repositories/repository.dart';

class RemoveSessionData {
  final Repository repository;

  RemoveSessionData(this.repository);

  Future<Either<Failure, String>> execute(SessionData data) {
    return repository.removeSessionData(data);
  }
}
