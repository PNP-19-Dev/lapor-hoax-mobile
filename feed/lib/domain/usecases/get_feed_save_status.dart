import 'package:core/domain/repositories/repository.dart';

class GetFeedSaveStatus {
  final Repository repository;

  GetFeedSaveStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToSavedFeed(id);
  }
}
