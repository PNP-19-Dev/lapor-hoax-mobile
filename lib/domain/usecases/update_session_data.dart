import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class UpdateSessionData {
  final Repository repository;

  UpdateSessionData(this.repository);

  Future<Either<Failure, String>> execute(SessionData data) {
    return repository.updateSessionData(data);
  }
}
