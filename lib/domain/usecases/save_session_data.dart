import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class SaveSessionData {
  final Repository repository;

  SaveSessionData(this.repository);

  Future<Either<Failure, String>> execute(SessionData data) {
    return repository.saveSessionData(data);
  }
}
