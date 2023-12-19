import 'package:fpdart/fpdart.dart';
import 'package:ia/others/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;