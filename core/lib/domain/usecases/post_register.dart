import 'package:dartz/dartz.dart';

import '../../data/models/register_model.dart';
import '../../data/models/user_response.dart';
import '../../utils/failure.dart';
import '../repositories/repository.dart';

class PostRegister {
  final Repository repository;

  PostRegister(this.repository);

  Future<Either<Failure, UserResponse>> execute(RegisterModel user) {
    return repository.postRegister(user);
  }
}
