import 'package:dartz/dartz.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/utils/failure.dart';

class GetSessionData {
  final Repository repository;

  GetSessionData(this.repository);

  Future<Either<Failure, SessionData?>> execute() {
    return repository.getSessionData();
  }
}
