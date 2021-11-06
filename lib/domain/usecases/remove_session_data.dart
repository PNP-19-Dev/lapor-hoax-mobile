import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class RemoveSessionData {
  final Repository repository;

  RemoveSessionData(this.repository);

  Future<String> execute(SessionData data) {
    return repository.removeSessionData(data);
  }
}
