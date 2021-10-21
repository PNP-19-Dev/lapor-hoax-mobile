import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/data/models/register_model.dart';
import 'package:laporhoax/data/models/user_response.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class PostRegister {
  final Repository repository;

  PostRegister(this.repository);

  Future<Either<Failure, UserResponse>> execute(RegisterModel user) {
    return repository.postRegister(user);
  }
}
