import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'failures.dart';

class ErrorHandler {
  static Future<Either<Failure, T>> execute<T>(Future<T> Function() apiCall) async {
    try {
      final result = await apiCall();
      return Right(result);
    } on SocketException catch (_) {
      return const Left(ServerFailure('Connection refused. Please check your internet connection or server status.'));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        return const Left(ServerFailure('Connection timed out. Please try again later.'));
      } else if (e.type == DioExceptionType.connectionError) {
        return const Left(ServerFailure('Failed to connect to the server. Please check your network connection.'));
      }
      
      final message = e.response?.data is Map<String, dynamic> 
          ? e.response?.data['message'] 
          : 'An error occurred';
      return Left(ServerFailure(message ?? 'An error occurred'));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred.'));
    }
  }
}
