import 'package:dartz/dartz.dart';

import '../../utils/failure.dart';
import '../entities/session_data.dart';
import '../repositories/repository.dart';

class SaveSessionData {
  final Repository repository;

  SaveSessionData(this.repository);

  Future<Either<Failure, String>> execute(SessionData data) {
    return repository.saveSessionData(data);
  }
}
