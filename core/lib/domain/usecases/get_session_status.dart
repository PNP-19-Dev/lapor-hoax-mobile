import '../repositories/repository.dart';

class GetSessionStatus {
  final Repository repository;

  GetSessionStatus(this.repository);

  Future<bool> execute() {
    return repository.isSessionActivated();
  }
}
