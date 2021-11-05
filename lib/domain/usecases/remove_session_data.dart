import 'package:dartz/dartz.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/utils/failure.dart';

class RemoveSessionData {
  final Repository repository;

  RemoveSessionData(this.repository);

  Future<Either<Failure, String>> execute(SessionData data) {
    return repository.removeSessionData(data);
  }
}
