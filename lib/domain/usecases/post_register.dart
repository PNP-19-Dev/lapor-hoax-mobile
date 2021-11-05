import 'package:dartz/dartz.dart';
import 'package:laporhoax/common/failure.dart';
import 'package:laporhoax/domain/entities/register.dart';
import 'package:laporhoax/domain/entities/register_data.dart';
import 'package:laporhoax/domain/repositories/repository.dart';

class PostRegister {
  final Repository repository;

  PostRegister(this.repository);

  Future<Either<Failure, RegisterData>> execute(Register user) {
    return repository.postRegister(user);
  }
}
